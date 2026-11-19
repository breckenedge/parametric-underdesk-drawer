param([string]$dump)
$src = @"
using System;
using System.Collections.Generic;
using System.Globalization;
public class CamSim {
  public List<double[]> segs = new List<double[]>();
  public double R, pr, uStop;
  // latch arm: pivot-to-pin radius Ra, pin offset Rc where the arm points straight (0 = straight slider)
  public static double Ra = 0, Rc = 0;
  public static double Hx(double u, double v) { if (Ra <= 0) return u; double s = v - Rc; return u - Ra + Math.Sqrt(Ra*Ra - s*s); }
  double[] ox, oy;
  public CamSim(double R, double pr, double uStop) {
    this.R = R; this.pr = pr; this.uStop = uStop;
    var xs = new List<double>(); var ys = new List<double>();
    xs.Add(0); ys.Add(0);
    foreach (double rr in new double[]{pr, pr*0.5})
      for (int k = 0; k < 48; k++) { double a = 2*Math.PI*k/48; xs.Add(rr*Math.Cos(a)); ys.Add(rr*Math.Sin(a)); }
    ox = xs.ToArray(); oy = ys.ToArray();
  }
  // groove segment given in (u, v); stored in housing coords, split so the arc correction follows it
  public void Add(double ax, double ay, double bx, double by) {
    int n = Ra > 0 ? 16 : 1;
    for (int k = 0; k < n; k++) {
      double u0 = ax + (bx-ax)*k/n, v0 = ay + (by-ay)*k/n, u1 = ax + (bx-ax)*(k+1)/n, v1 = ay + (by-ay)*(k+1)/n;
      segs.Add(new double[]{Hx(u0,v0), v0, Hx(u1,v1), v1});
    }
  }
  bool InG(double x, double y) {
    foreach (var s in segs) {
      double dx = s[2]-s[0], dy = s[3]-s[1];
      double L2 = dx*dx+dy*dy;
      double t = L2 > 0 ? ((x-s[0])*dx+(y-s[1])*dy)/L2 : 0;
      t = Math.Max(0, Math.Min(1, t));
      double px = s[0]+t*dx - x, py = s[1]+t*dy - y;
      if (px*px+py*py <= R*R + 1e-9) return true;
    }
    return false;
  }
  public bool Valid(double u, double v) {
    double h = Hx(u, v);   // pin centre in housing coords
    for (int i = 0; i < ox.Length; i++) if (!InG(h+ox[i], v+oy[i])) return false;
    return true;
  }
  // one quasi-static step; returns false if blocked
  public bool Step(ref double u, ref double v, double du, double bias) {
    double nu = u + du, maxdv = Math.Abs(du)*Math.Tan(75*Math.PI/180);
    double best = double.NaN;
    for (double d = 0; d <= maxdv + 1e-9; d += 0.002) {
      if (Valid(nu, v + d)) { best = v + d; break; }
      if (Valid(nu, v - d)) { best = v - d; break; }
    }
    if (double.IsNaN(best)) return false;
    u = nu; v = best;
    double moved = 0;
    while (moved < bias && Math.Abs(v - Rc) > 0.002) {
      double st = Math.Min(0.01, Math.Abs(v - Rc)) * -Math.Sign(v - Rc);
      if (!Valid(u, v + st)) break;
      v += st; moved += Math.Abs(st);
    }
    return true;
  }
  public string Push(ref double u, ref double v, double target, double bias) {
    while (u < target) if (!Step(ref u, ref v, Math.Min(0.02, target-u), bias))
      return String.Format(CultureInfo.InvariantCulture, "JAM at u={0:F2} v={1:F2}", u, v);
    return String.Format(CultureInfo.InvariantCulture, "pushed to u={0:F2} v={1:F2}", u, v);
  }
  public string Release(ref double u, ref double v, double bias) {
    while (u > -12) if (!Step(ref u, ref v, -0.02, bias))
      return String.Format(CultureInfo.InvariantCulture, "LATCHED at u={0:F2} v={1:F2}", u, v);
    return String.Format(CultureInfo.InvariantCulture, "EJECTED (u={0:F2} v={1:F2})", u, v);
  }
}
"@
Add-Type -TypeDefinition $src
$ci = [Globalization.CultureInfo]::InvariantCulture
$lines = Get-Content $dump
$cam = ($lines | Where-Object { $_ -match 'CAM ' })
$R  = [double]::Parse(([regex]::Match($cam,'r_eff=([\d.]+)')).Groups[1].Value, $ci)
$pr = [double]::Parse(([regex]::Match($cam,'pin_r=([\d.]+)')).Groups[1].Value, $ci)
$us = [double]::Parse(([regex]::Match($cam,'u_stop=([\d.]+)')).Groups[1].Value, $ci)
$arm = ($lines | Where-Object { $_ -match 'ARM ' })
if ($arm) {
  [CamSim]::Ra = [double]::Parse(([regex]::Match($arm,'r=([\d.]+)')).Groups[1].Value, $ci)
  [CamSim]::Rc = [double]::Parse(([regex]::Match($arm,'rest=([\d.]+)')).Groups[1].Value, $ci)
  "latch arm: pivot-to-pin " + [CamSim]::Ra + " mm, straight at v=" + [CamSim]::Rc
}
function New-Sim {
  $s = New-Object CamSim($R, $pr, $us)
  $s.Add(-30, 0, 0, 0)  # mouth channel
  foreach ($l in ($lines | Where-Object { $_ -match 'PATH ' })) {
    $pts = [regex]::Matches($l, '\[(-?[\d.]+), (-?[\d.]+)\]') | ForEach-Object { ,@([double]::Parse($_.Groups[1].Value,$ci), [double]::Parse($_.Groups[2].Value,$ci)) }
    for ($i = 0; $i -lt $pts.Count - 1; $i++) { $s.Add($pts[$i][0], $pts[$i][1], $pts[$i+1][0], $pts[$i+1][1]) }
  }
  return $s
}
foreach ($bias in @(100.0, 0.004, 0.0)) {
  "=== blade bias per 0.02mm step: $bias ==="
  $s = New-Sim; [double]$u = -10; [double]$v = 0
  for ($c = 1; $c -le 3; $c++) {
    "  push $c : " + $s.Push([ref]$u, [ref]$v, $us, $bias)
    "  release : " + $s.Release([ref]$u, [ref]$v, $bias)
  }
}
"=== partial strokes (full bias) ==="
$s = New-Sim; [double]$u = -10; [double]$v = 0
"  push to 15 : " + $s.Push([ref]$u, [ref]$v, 15, 100) + " -> " + $s.Release([ref]$u, [ref]$v, 100)
"  full push  : " + $s.Push([ref]$u, [ref]$v, $us, 100) + " -> " + $s.Release([ref]$u, [ref]$v, 100)
"  latched, push 1.5mm : " + $s.Push([ref]$u, [ref]$v, $u + 1.5, 100) + " -> " + $s.Release([ref]$u, [ref]$v, 100)
"  latched, push 4mm   : " + $s.Push([ref]$u, [ref]$v, $u + 4, 100) + " -> " + $s.Release([ref]$u, [ref]$v, 100)
"  latched, push 5.5mm : " + $s.Push([ref]$u, [ref]$v, $u + 5.5, 100) + " -> " + $s.Release([ref]$u, [ref]$v, 100)
"  full push  : " + $s.Push([ref]$u, [ref]$v, $us, 100) + " -> " + $s.Release([ref]$u, [ref]$v, 100)
"=== stop tolerance: panel stop +/-0.8 mm ==="
foreach ($d in @(-0.8, 0.8)) {
  $s = New-Sim; [double]$u = -10; [double]$v = 0
  $r1 = $s.Push([ref]$u, [ref]$v, $us + $d, 100) + " -> " + $s.Release([ref]$u, [ref]$v, 100)
  $r2 = $s.Push([ref]$u, [ref]$v, $us + $d, 100) + " -> " + $s.Release([ref]$u, [ref]$v, 100)
  "  stop $d : $r1 | $r2"
}
