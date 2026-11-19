param([string]$dump, [double]$grid = 0.05)
# Bounce margin of the latch: after push 1 the drawer springs back out and the pin must land in
# the notch. Momentum (the arm swinging sideways, the drawer bouncing off the catch) can let it
# go anywhere the groove allows, so this ignores the band entirely and asks: how far must the
# drawer move back IN (against the ejector) at some point on the way out for the pin to reach
# the exit column? Any sideways pin motion is allowed. Bigger = more robust.
# Run with the geometry dump from part="cam_paths" (see camsim.ps1).
$src = @"
using System;
using System.Collections.Generic;
public class CamMargin {
  public List<double[]> segs = new List<double[]>();
  public double R; public static double Ra = 0, Rc = 0;
  double[] ox, oy;
  public static double Hx(double u, double v) { if (Ra <= 0) return u; double s = v - Rc; return u - Ra + Math.Sqrt(Ra*Ra - s*s); }
  public CamMargin(double R, double pr) {
    this.R = R; var xs = new List<double>(); var ys = new List<double>(); xs.Add(0); ys.Add(0);
    for (int k = 0; k < 48; k++) { double a = 2*Math.PI*k/48; xs.Add(pr*Math.Cos(a)); ys.Add(pr*Math.Sin(a)); }
    ox = xs.ToArray(); oy = ys.ToArray();
  }
  public void Add(double ax, double ay, double bx, double by) {
    int n = Ra > 0 ? 16 : 1;
    for (int k = 0; k < n; k++) {
      double u0 = ax + (bx-ax)*k/n, v0 = ay + (by-ay)*k/n, u1 = ax + (bx-ax)*(k+1)/n, v1 = ay + (by-ay)*(k+1)/n;
      segs.Add(new double[]{Hx(u0,v0), v0, Hx(u1,v1), v1});
    }
  }
  bool InG(double x, double y) {
    foreach (var s in segs) {
      double dx = s[2]-s[0], dy = s[3]-s[1], L2 = dx*dx+dy*dy;
      double t = L2 > 0 ? ((x-s[0])*dx+(y-s[1])*dy)/L2 : 0; t = Math.Max(0, Math.Min(1, t));
      double px = s[0]+t*dx - x, py = s[1]+t*dy - y;
      if (px*px+py*py <= R*R + 1e-9) return true;
    }
    return false;
  }
  public bool Valid(double u, double v) { double h = Hx(u, v); for (int i = 0; i < ox.Length; i++) if (!InG(h+ox[i], v+oy[i])) return false; return true; }

  bool[,] ok; double u0, v0, g; int nu, nv;
  public void Grid(double ua, double ub, double va, double vb, double g) {
    this.g = g; u0 = ua; v0 = va; nu = (int)((ub-ua)/g)+1; nv = (int)((vb-va)/g)+1; ok = new bool[nu, nv];
    for (int i = 0; i < nu; i++) for (int j = 0; j < nv; j++) ok[i,j] = Valid(u0+i*g, v0+j*g);
  }
  // can the pin get from (su, sv) to v <= vGoal (the exit column) if the drawer may move back in by at most b
  // (measured from the lowest u reached so far)? 8-connected grid flood, best-first on running min.
  public bool Escapes(double su, double sv, double vGoal, double b) {
    var best = new double[nu, nv];
    for (int i = 0; i < nu; i++) for (int j = 0; j < nv; j++) best[i,j] = double.NegativeInfinity;
    int si = (int)Math.Round((su-u0)/g), sj = (int)Math.Round((sv-v0)/g);
    // snap the start to the nearest valid cell
    double bd = 1e9; int bi = -1, bj = -1;
    for (int i = Math.Max(0,si-20); i < Math.Min(nu,si+21); i++) for (int j = Math.Max(0,sj-20); j < Math.Min(nv,sj+21); j++)
      if (ok[i,j]) { double d = (i-si)*(i-si)+(j-sj)*(j-sj); if (d < bd) { bd = d; bi = i; bj = j; } }
    if (bi < 0) throw new Exception("start not in groove");
    var pq = new SortedSet<Tuple<double,int,int>>(Comparer<Tuple<double,int,int>>.Create((a, c) => {
      int r = c.Item1.CompareTo(a.Item1); if (r != 0) return r; r = a.Item2.CompareTo(c.Item2); return r != 0 ? r : a.Item3.CompareTo(c.Item3); }));
    best[bi,bj] = u0+bi*g; pq.Add(Tuple.Create(best[bi,bj], bi, bj));
    while (pq.Count > 0) {
      var t = pq.Min; pq.Remove(t); double m = t.Item1; int i = t.Item2, j = t.Item3;
      if (m < best[i,j]) continue;
      if (v0 + j*g <= vGoal) return true;
      for (int di = -1; di <= 1; di++) for (int dj = -1; dj <= 1; dj++) {
        int a = i+di, c = j+dj; if (a < 0 || c < 0 || a >= nu || c >= nv || !ok[a,c]) continue;
        double ua = u0 + a*g; if (ua > m + b + 1e-9) continue;
        double m2 = Math.Min(m, ua);
        if (m2 > best[a,c]) { best[a,c] = m2; pq.Add(Tuple.Create(m2, a, c)); }
      }
    }
    return false;
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
  [CamMargin]::Ra = [double]::Parse(([regex]::Match($arm,'r=([\d.]+)')).Groups[1].Value, $ci)
  [CamMargin]::Rc = [double]::Parse(([regex]::Match($arm,'rest=([\d.]+)')).Groups[1].Value, $ci)
}
$s = New-Object CamMargin($R, $pr)
$s.Add(-30, 0, 0, 0)
$ends = New-Object System.Collections.Generic.List[double[]]   # last point of each path
foreach ($l in ($lines | Where-Object { $_ -match 'PATH ' })) {
  $m = [regex]::Matches($l, '\[(-?[\d.]+), (-?[\d.]+)\]')
  $us_ = @(); $vs_ = @()
  foreach ($x in $m) { $us_ += [double]::Parse($x.Groups[1].Value,$ci); $vs_ += [double]::Parse($x.Groups[2].Value,$ci) }
  for ($i = 0; $i -lt $us_.Count - 1; $i++) { $s.Add($us_[$i], $vs_[$i], $us_[$i+1], $vs_[$i+1]) }
  $ends.Add([double[]]@($us_[-1], $vs_[-1]))
}
$o = $ends.Count - 4
$vtr = $ends[$o][1]                     # stroke-1 end column
$ua = $ends[$o+1][0]; $vn = $ends[$o+1][1]   # notch
$vle = $ends[$o+2][1]                     # stroke-2 end / exit column
$ErrorActionPreference = 'Stop'
# the exit column. (Going back right, down the entry, is also open with no band at all - the band pulling
# left is what stops that, and momentum on this stroke is leftward, so only the left escape is measured.)
$vGoal = $vle + 0.3
$s.Grid($ua - 4, $us + 1.5, $vle - 4, $vtr + 3, $grid)
$lo = 0.0; $hi = 6.0
if ($s.Escapes($us, $vtr, $vGoal, 0)) { "bounce margin after push 1: 0 (escapes even without bouncing - geometry broken)"; exit }
while ($hi - $lo -gt $grid) { $mid = ($lo + $hi) / 2; if ($s.Escapes($us, $vtr, $vGoal, $mid)) { $hi = $mid } else { $lo = $mid } }
"bounce margin after push 1: {0:F2} mm (the drawer must move back in this far, mid-return, for the pin to skip the catch)" -f $lo
