// =====================================================================
//  Parametric Under-Desk Drawer  —  push-to-open, support-free
//  OpenSCAD (nightly, Manifold backend recommended)
//
//  Parts:
//    housing : screws to the underside of the desk. Print UPSIDE DOWN
//              (desk face on the bed) – exported that way.
//    drawer  : print upright, floor on the bed.
//    arm     : latch arm; print flat, pin up.
//
//  Slide   : 45° dovetail lips on the drawer ride on 45° ledges in the
//            housing. Self-centering, no bearings, no supports.
//  Latch   : push-push heart-cam groove cut into the housing plate. A rigid
//            arm carrying the pin swings sideways on a post in a pocket at the
//            drawer's back centre; a rubber band stretched past both sides of it
//            (spreader in front, post behind) pulls it back to centre. No printed part flexes.
//  Ejector : small drawers: one rubber band stretched between two posts under the
//            housing walls; the drawer's back wall pushes it back on close.
//            Wide ones: a short band per side, from a post under the housing to a
//            hook on the drawer's side wall (picked automatically).
//
//  Hardware: countersunk wood screws (default #8 / 4 mm; 4 on small drawers, more
//            on long ones – see screw_spacing), two rubber bands.
// =====================================================================

/* [Output] */
// assembly: F5 shows it assembled, F6 renders all parts laid out for printing
part = "assembly"; // [assembly, print_layout, housing, drawer, arm, cam_2d, cam_paths]
// Show drawer pulled out this far in the assembly view (mm)
assembly_open = 0;

/* [Drawer interior (mm)] */
// Minimums are the smallest sizes that work with defaults for everything else:
// width – the latch arm's swing; depth – the latch arm and its band (spreader to back post);
// height – drawer must reach below the ejector band.
// Defaults are the minimums – a small, quick test print.
inner_w = 47;  // [47:1:500]
inner_d = 62;  // [62:1:500]
inner_h = 17;  // [17:1:300]
// Number of lengthwise dividers (0 = none)
dividers = 0;

/* [Drawer walls] */
wall = 2.0;
floor_t = 1.6;
panel_t = 4;
// Extra front-panel width beyond the housing on each side
panel_margin = 0;
// Gap between front-panel top edge and the desk
panel_top_gap = 1.0;

/* [Slide] */
// Size of the 45° lip on each side of the drawer
lip = 5;
// Small vertical flat on the lip tip
lip_edge = 1.5;
// Gap across the 45° sliding faces (perpendicular)
slide_clr = 0.35;
// Gap between lip tip and housing wall
side_clr = 0.6;
// Gap between drawer rim and housing plate
top_gap = 1.0;
// Material under the ledge's 45° face at its thinnest
ledge_min = 3;
housing_wall = 3;
plate_t = 5;

/* [Desk screws] */
// Countersunk wood screw size (US gauge / metric equivalent)
screw = 4; // [3.5:#6 / 3.5 mm, 4:#8 / 4 mm, 4.5:#9 / 4.5 mm, 5:#10 / 5 mm]
// Most space allowed between screws along each side. Each side gets as many as
// that needs (never fewer than 2), so small drawers use 4 screws and longer ones more.
screw_spacing = 100; // [40:5:200]

/* [Push latch] */
// Where the latch track (in the housing) and its mechanism (in the drawer) go, seen from the
// front. left / right put them as close to that side as fits (clear of the side wall, the
// screws and the rounded back corner), leaving one big open area in the drawer.
latch_side = "center"; // [center, left, right]
// Extra sideways shift of the latch, mm (+ = toward the left). Added to the centre or side position.
latch_y = 0;
pin_d = 3;
// Radial clearance between pin and groove
pin_clr = 0.35;
// Minimum printed wall between groove branches
cam_wall_min = 1.6;
groove_depth = 3.4;
// Pin protrusion above the drawer rim
pin_h = 3.2;
// How far short of the groove end the panel stops the drawer
stop_back = 1.2;

/* [Latch arm] */
// Rigid arm (separate part) that carries the pin. It swings sideways on a post
// at its front end, so it can't jam or tip like a slider. The groove is
// corrected for the arc the pin travels.
arm_r = 26;       // pivot to pin
arm_w = 8;        // width at the tip
arm_h = 7;
// Radial clearance between the arm's hub and its pivot post
arm_clr = 0.2;
arm_post_d = 5;
// Centring band: one band stretched lengthwise around a spreader in front of the
// arm's hub and a post behind its tip. The arm sits between the two strands; when
// it swings, its tip pushes one strand out like a bowstring. Nothing to thread,
// and a doubled band works too.
cband_back = 8;       // arm tip end to the back post
cband_spread = 13;    // spreader width (strand spacing at the front)
cpost_d = 4;
// Deep drawers: instead of standing on the drawer floor, the latch mechanism sits on a
// flat floor just under the arm (so its posts stay short and stiff), carried by a solid
// wedge whose underside slopes 45° down to the back wall (prints without support). The
// space under it is usable. Used when that leaves at least this much height under the
// pocket's front edge (0 = whenever possible, 300 = never).
mech_slope_min = 10; // [0:1:300]

/* [Rubber band ejector] */
// Picked automatically (the console says which and why). Small drawers: one band across the
// back of the drawer, which gets longer as the drawer gets wider. Once that band would need a
// flat length over 1.5 x side_band_len, and the drawer is deep and tall enough for the hooks:
// one band per side instead, looped around a post under the housing and a hook on the
// drawer's side wall, so a short band works on any size of drawer.
// Flat (unstretched) length of the bands you'll use on the side hooks, mm (2.5" = 64)
side_band_len = 64;
// How far the ejector pushes: the band is stretched this much as the drawer closes
band_stroke = 32;
post_d = 6;
// Band height below the housing bottom
band_drop = 6;
// Radius of the drawer's two back corners, where the band wraps (sharp corners cut it)
back_r = 6; // [3:0.5:12]

/* [Plate lightening] */
plate_windows = true;
window_rib = 8;
window_target = 40;

/* [Hidden] */
$fn = $preview ? 32 : 64;
eps = 0.01;
s2 = sqrt(2);
// Countersunk wood screws: [nominal shank d, max head d]. Head sizes are the
// metric (DIN 7505 / ISO 7046) maxima, which also cover the US flat-head gauges.
screw_table = [[3.5, 7.0], [4.0, 8.0], [4.5, 9.0], [5.0, 10.0]];
// tolerate "4" (string) from -D or presets saved with the earlier version
screw_n = is_string(screw) ? [for (r = screw_table) if (str(r[0]) == screw) r[0]][0] : screw;
screw_hits = [for (r = screw_table) if (abs(r[0] - screw_n) < 0.01) r];
assert(len(screw_hits) == 1, str("Unknown screw size ", screw, " – pick one from the list"));
screw_d      = screw_hits[0][0] + 0.4;   // clearance hole
screw_head_d = screw_hits[0][1] + 0.6;   // countersink diameter at flush
// Extra recess below flush so heads never touch the drawer
screw_recess = 0.4;

// Sizes below the minimums (e.g. a value the Customizer kept from an older version
// of this file) are raised to the minimum, with a warning, instead of failing.
min_w = 47;  min_d = 62;  min_h = 17;
in_w = max(inner_w, min_w);
in_d = max(inner_d, min_d);
in_h = max(inner_h, min_h);
for (c = [["inner_w", inner_w, min_w], ["inner_d", inner_d, min_d], ["inner_h", inner_h, min_h]])
  if (c[1] < c[2]) echo(str("WARNING: ", c[0], " = ", c[1], " is below the minimum – using ", c[2], " mm"));
// ------------------------------------------------------------- derived
Wd = in_w + 2*wall;            // drawer outer width (body)
Dd = in_d + 2*wall;            // drawer outer depth (body)
Hd = in_h + floor_t;           // drawer outer height (body)
z_rim = -plate_t - top_gap;       // drawer rim (use coords, desk = z0)
z_bot = z_rim - Hd;
y_wo = Wd/2;                      // drawer wall outer face
y_li = y_wo + side_clr;           // ledge inner edge
y_hi = y_wo + lip + side_clr;     // housing wall inner face
y_ho = y_hi + housing_wall;       // housing outer face
Dh = Dd;                          // housing depth

function ledge_top(y) = z_rim - lip_edge - lip + (y - y_wo) - slide_clr*s2;
z_hbot = ledge_top(y_li) - ledge_min;

// ------------------------------------------------------------- cam geometry
// Cam coordinates: u = depth (+ = deeper into housing), v = lateral.
// Everything below describes the PIN CENTRE path; the groove is that
// path grown by r_eff.
r_eff = pin_d/2 + pin_clr;
cam_g = 2*r_eff + cam_wall_min;   // centre-to-centre spacing for a solid wall
v_l  = -cam_g;                    // exit channel (left of island nose)
v_le = 2;                         // stroke-2 end / exit column
v_n  = v_le + cam_g;              // latch notch
v_tr = v_n + 4;                   // stroke-1 end column
v_rc = v_tr + 4;                  // right channel (max sideways pin travel)
ramp_ang = 50;
u_1  = abs(v_l) + 1.7;
u_2  = u_1 + v_rc / tan(ramp_ang);
u_C  = u_2 + 0.5;
u_D  = u_C + (v_rc - v_tr);
U    = u_D + 2.5;                 // groove end
u_drop = 1.5;                     // P2 falls straight this far before turning toward the notch
u_a  = u_D - 4.6 - u_drop;        // latch notch (apex)
// Exit S-curve (P4): after release the pin has to cross from the stroke-2 column over to the left
// channel against the centring band, so the groove's wall is what pushes it. A sharp 45° corner
// there makes the drawer stutter; this cosine curve has no corners and its steepest point is
// about 35° off straight, so the pin gets pushed across gradually.
p4_e = 2.3;  p4_len = 16;
u_4e = abs(v_l) + p4_e;                       // reaches the left channel here...
u_4s = u_4e + p4_len;                          // ...having started to turn here
p4_curve = [for (i = [0:16]) let(t = i/16)
  [u_4s - p4_len*t, v_le - (v_le - v_l)*(0.5 - 0.5*cos(180*t))]];
u_stop = U - stop_back;           // pin position when panel hits housing

// Bounce margin: on the way out after push 1 the band pulls the pin toward the exit side,
// and with momentum (arm swing, drawer bounce, pivot play – worse when the drawer isn't
// level and nothing damps the arm) it can cut over to the exit. P2 drops straight first so
// it reaches the exit diagonal (P3) low, and P3 climbs to above u_D: the drawer would have
// to move back in ~1.8 mm mid-return to skip the catch (tools/cammargin.ps1; was 0.66).
cam_paths = [
  // P1: entry straight, ramp, right channel, over to stroke-1 end
  [[0,0],[u_1,0],[u_2,v_rc],[u_C,v_rc],[u_D,v_tr],[U,v_tr]],
  // P2: drop straight from stroke-1 end, then over into the notch
  [[u_D,v_tr],[u_D-u_drop,v_tr],[u_a+0.6,v_n],[u_a,v_n]],
  // P3: notch straight up (from latched, a 4 mm push still re-latches; ~5 mm releases), then forced left to stroke-2 end
  [[u_a,v_n],[u_a+2.8,v_n],[u_D+0.5,v_le],[U,v_le]],
  // P4: exit around the left of the island back to the mouth, on a smooth S-curve
  concat([[U,v_le]], p4_curve, [[abs(v_l),v_l],[0,0]])
];

// the exit curve must leave a solid wall (cam_g centre to centre) to the entry, ramp and notch paths
function seg_dist(p, a, b) = let(d = b - a, t = max(0, min(1, (p - a)*d / max(1e-9, d*d)))) norm(a + d*t - p);
p4_gap = min([for (q = p4_curve, k = [0, 1]) let(P = cam_paths[k]) for (i = [0:len(P)-2]) seg_dist(q, P[i], P[i+1])]);
assert(p4_gap >= cam_g - 0.05, str("exit curve runs within ", p4_gap, " mm of another groove path (needs ", cam_g, ")"));

// The centring band holds the arm (and pin) at v = cam_rest_v. Simulation shows
// the latch cycles correctly for rest positions from v = -0.25 to +2 (tools/camsim_rest_offset.ps1),
// so 1.0 is about centred: -1.25 / +1 mm tolerance for pivot friction / an uneven band.
cam_rest_v = 1.0;

// arm / pin placement (drawer coords; equal to housing coords when closed)
throw_r = v_rc - cam_rest_v + pin_clr;          // max pin travel from rest, each way
throw_l = abs(v_l) + cam_rest_v + pin_clr;
spool_fl = 1;                                   // band post flare (radius added)
// Place the arm so the groove's lateral extent (v_l..v_rc) is centred, or as far to one side
// as fits, then shift by latch_y. +y is the drawer's left, seen from the front.
yb_c = -((v_l + v_rc)/2 - cam_rest_v);          // arm centre line for a centred groove
// how far each part reaches from the arm's centre line toward +y (hi) and -y (lo)
lat_pocket_hi = throw_r + arm_w/2 + 2.5 + 1.2;   lat_pocket_lo = throw_l + arm_w/2 + 2.5 + 1.2;
lat_groove_hi = v_rc - cam_rest_v + r_eff;       lat_groove_lo = cam_rest_v - v_l + r_eff;
lat_post = cpost_d/2 + spool_fl + 0.5;          // back band post vs the rounded back corner
lat_screw_y = y_li - (screw_head_d/2 + screw_recess) - 1;   // same as screw_y (defined below)
// furthest the arm's centre line may go each way: 0.5 mm inside every check further down
// (side wall, screw rows, rounded back corner)
yb_hi =  min(Wd/2 - wall - 5 - lat_pocket_hi, lat_screw_y - 1 - screw_head_d/2 - lat_groove_hi,
             Wd/2 - back_r - lat_post) - 0.5;
yb_lo = -min(Wd/2 - wall - 5 - lat_pocket_lo, lat_screw_y - 1 - screw_head_d/2 - lat_groove_lo,
             Wd/2 - back_r - lat_post) + 0.5;
yb = latch_y + (latch_side == "left"  ? max(yb_hi, yb_c) :
                latch_side == "right" ? min(yb_lo, yb_c) : yb_c);   // arm centre line (pin at rest)
x_bpost = Dd - wall - 2 - cpost_d/2;            // 2 mm behind it for the band to wrap
x_tip = x_bpost - cband_back;                   // arm tip end (rounded, radius arm_w/2)
x_pin = x_tip - arm_w/2;                        // pin sits at the centre of the rounded tip
x_pv  = x_pin - arm_r;                          // pivot post
hub_d = arm_post_d + 2*arm_clr + 2*2.4;
a_tip = arm_r + arm_w/2;                        // pivot to tip end
x_sp  = x_pv - hub_d/2 - 1 - cpost_d/2 - spool_fl;   // spreader, just clear of the hub
phi_l = asin(min(1, throw_l / arm_r));          // arm swing each way (deg)
phi_r = asin(min(1, throw_r / arm_r));
x_cam0 = x_pin - u_stop;          // housing x of cam origin u=0
// The pin swings on an arc: at lateral offset s from rest it sits arm_r - sqrt(arm_r²-s²)
// further forward, so the groove is drawn through that correction.
function cam2h(p) = let(s = p[1] - cam_rest_v)
  [x_cam0 + p[0] - arm_r + sqrt(arm_r*arm_r - s*s), yb + s];
groove_y0 = yb - cam_rest_v + v_l  - r_eff;   // groove lateral extent in housing coords
groove_y1 = yb - cam_rest_v + v_rc + r_eff;

// pocket: guard walls around the arm's swing and the band (outer faces)
pocket_y0 = yb - throw_l - arm_w/2 - 2.5 - 1.2;
pocket_y1 = yb + throw_r + arm_w/2 + 2.5 + 1.2;
pocket_x0 = x_sp - cpost_d/2 - spool_fl - 1.5 - 1.2;
// what the pocket actually encloses: a gap to a side wall too narrow to use (< 12 mm) is
// closed off by running the pocket out to that wall
pocket_y0w = pocket_y0 - (-Wd/2 + wall) < 12 ? -Wd/2 + wall - eps : pocket_y0;
pocket_y1w = Wd/2 - wall - pocket_y1 < 12 ?  Wd/2 - wall + eps : pocket_y1;

// arm heights (world z, use orientation)
z_arm = z_rim - arm_h;                          // arm bottom; its top is flush with the rim
z_tun = z_arm + arm_h/2;                        // band height

// raised pocket floor: flat top at z_mf (2 mm under the arm, so the posts stay short), on a
// solid wedge whose underside falls 45° from the pocket's front edge to the back wall
z_mf = z_arm - 2;
mech_gap = z_mf - floor_t - (z_bot + floor_t);  // free height under the pocket's front edge
mech_slope = mech_gap >= max(mech_slope_min, 1);
function mf_under(x) = z_mf - floor_t - (x - pocket_x0);   // underside of the wedge
// band strands at rest: straight from the spreader's sides to the back post's sides
function band_y(x) = cband_spread/2 + (cpost_d/2 - cband_spread/2) * (x - x_sp) / (x_bpost - x_sp);
cband_len = norm([x_bpost - x_sp, cband_spread/2 - cpost_d/2]);
cband_loop = 2*cband_len + PI*cpost_d + (cband_spread - cpost_d);

// band posts. The back band is fed through two loops on the drawer's back, so it stays with the
// drawer: pulled past the posts it stretches the other way and pulls the drawer back. A band
// released from closed swings the drawer out to about 2 x the stroke at most (it gives back what
// it stored), so the stroke is cut on short drawers to keep 15 mm of the drawer in the housing.
bb_stroke = min(band_stroke, floor((Dd - 15)/2));
x_post = Dd - bb_stroke + post_d/2;
y_post = y_ho - post_d/2;
z_band = z_hbot - band_drop;
back_band_len = round(0.9 * 2*y_post);          // flat length of a back band
bl_w = 6;                                       // back band loops: width along the back
y_bl = Wd/2 - back_r - bl_w/2 - 1;              // on the flat of the back wall, near the corners
bl_r = 3;                                       // radius of the band's tunnel (6 mm tall, 3 deep)
// how far the drawer opens before the back band is stretched 2.5x (a firm pull)
bl_half = (2.5*back_band_len - 2*y_bl) / 2;
bb_open25 = bb_stroke + sqrt(max(0, bl_half*bl_half - pow(y_post - y_bl, 2)));

// side-hook ejector: the same posts under the housing walls, further forward, and a hook on
// each side wall of the drawer near its back: an arm sticking straight out of the wall with a
// lip at its end, like a coat hook. The band loops over the arm. The hook sits low enough to
// pass under the post when the drawer goes in or out (posts and hooks overlap sideways).
sh_w = 5;        // arm width (along the drawer)
sh_len = 6;      // arm length out from the wall
sh_ht = 3.5;     // arm height at its end (it gets taller toward the wall: 45° underside)
sh_lip = 2.5;    // lip height above the arm
sh_lt = 1.6;     // lip thickness
z_sht = z_band - 4.5 - 1.5 - sh_lip;            // arm top: lip top 1.5 under the post
z_sh = z_sht - sh_ht/2;                         // band height on the hook
y_sh = y_wo + sh_len - sh_lt - 1;               // band sits against the lip
x_sh = Dd - back_r - sh_w/2 - 2;                // on the flat of the side wall, near the back
sh_off = norm([y_post - y_sh, z_band - z_sh]);  // band's sideways + vertical offset, post to hook
sh_wrap = PI*post_d/2 + sh_w + sh_ht;           // band length wrapped around post and hook
// post-to-hook distance (along the drawer) at which the band goes slack; closed it is band_stroke more
sh_slack = sqrt(max(0, pow(side_band_len - sh_wrap/2, 2) - sh_off*sh_off));
x_spost = x_sh - sh_slack - band_stroke;        // housing post for the side bands
sh_stretch = (2*norm([sh_slack + band_stroke, sh_off]) + sh_wrap) / (2*side_band_len);
// smallest drawer the side hooks fit: post (with its flare) inside the housing, hook above the floor
sh_min_d = ceil(post_d/2 + 1.5 + 1 + sh_slack + band_stroke + back_r + sh_w/2 + 2 - 2*wall);
sh_min_h = ceil(z_rim - (z_sht - sh_ht) - floor_t);
sides_fit = in_d >= sh_min_d && in_h >= sh_min_h && side_band_len - sh_wrap/2 > sh_off + 10;
sides_want = back_band_len > 1.5 * side_band_len;
ej_sides = sides_want && sides_fit;

// Screws go in straight up from below with the drawer out, so the whole countersink
// (and the head/driver passing through it) must sit inside the ledges' inner edge.
screw_cs_r = screw_head_d/2 + screw_recess;
screw_y = y_li - screw_cs_r - 1;
screw_n_side = max(2, ceil((Dh - 24) / screw_spacing) + 1);   // screws per side, 12 mm in from each end
screw_xs = [for (i = [0:screw_n_side-1]) 12 + i * (Dh - 24) / (screw_n_side - 1)];

// ------------------------------------------------------------- checks
echo(str("Drawer body ", Wd, " x ", Dd, " x ", Hd, " mm; housing ", 2*y_ho, " x ", Dh,
         " x ", -z_hbot, " mm (+ band posts)"));
echo(str("Latched drawer sits ", u_stop - u_a, " mm proud; push-release travel the same"));
echo(str("Latch on the ", latch_side == "center" ? "centre line" : str(latch_side, " side"),
         ", room beside its pocket at the back: ", max(0, round(Wd/2 - wall - pocket_y1w)), " mm on the left, ",
         max(0, round(pocket_y0w + Wd/2 - wall)), " mm on the right"));
if (mech_slope) echo(str("Latch mechanism on a raised floor (45° wedge underneath): ", round(mech_gap),
                          " mm free under its front edge"));
echo(str("Desk screws: ",2*screw_n_side, " (", screw_n_side, " per side, ",
         round((Dh - 24)/(screw_n_side - 1)), " mm apart)"));
if (ej_sides)
  echo(str("Ejector: side bands – 2 bands of ", side_band_len, " mm flat length, one per side, each looped",
           " around the post under the housing and the hook on the drawer's side (a back band would need ~",
           back_band_len, " mm). Closed they are stretched ", round(sh_stretch*100)/100, "x. Opened more than ~",
           round(2*sh_slack + band_stroke), " mm they start pulling the drawer back in (a soft stop) – slip them",
           " off the hooks to take the drawer out"));
if (ej_sides && Dd - 2*(sh_slack + band_stroke) < 15)
  echo(str("WARNING: the side bands only start catching the drawer ~", round(2*sh_slack + band_stroke),
           " mm out, and a strong band can carry it ~", round(2*(sh_slack + band_stroke)),
           " mm before they stop it – more than this ", Dd, " mm drawer, so it can still be thrown out"));
if (!ej_sides) {
  echo(str("Ejector band: post spacing ", 2*y_post, " mm -> use a band with flat length ~",
           back_band_len, " mm (or a chain of bands). Feed it through the two loops on the drawer's back,",
           " then loop it around both posts. It also stops the drawer: released, the drawer settles about ",
           bb_stroke, " mm open, and even a strong band can't throw it out further than about ", 2*bb_stroke,
           " mm (of ", Dd, ")", bb_open25 < Dd - 15 ? str("; pulled out more than ~", round(bb_open25),
           " mm the band is stretched 2.5x") : ""));
  if (bb_stroke < band_stroke)
    echo(str("Ejector stroke cut to ", bb_stroke, " mm (band_stroke ", band_stroke,
             ") so the band can catch this short drawer"));
  if (sides_want)
    echo(side_band_len - sh_wrap/2 > sh_off + 10
         ? str("Side-hook ejector (", side_band_len, " mm bands) not used: it needs inner_d >= ", sh_min_d,
               " and inner_h >= ", sh_min_h)
         : str("Side-hook ejector not used: side_band_len ", side_band_len, " mm is too short for it"));
}
echo(str("Latch centring band: loop path ", round(cband_loop), " mm -> use a band of ~",
         round(cband_loop/1.5), " mm circumference (flat length ~", round(cband_loop/3),
         " mm), or a smaller one doubled"));
assert(z_arm - 2 > z_bot + floor_t, "Drawer too shallow for the latch arm – increase inner_h");
assert(throw_r < arm_r - 8, "arm_r too short for the cam's sideways travel");
assert(x_bpost - cpost_d/2 - spool_fl - x_tip >= 1.5, "cband_back too short – band post hits the arm tip");
assert(band_y(x_pv) >= hub_d/2 + 0.4, "latch band strands rub the arm's hub – increase cband_spread");
assert(band_y(x_pin) <= arm_w/2 - 0.4, "latch band strands don't press on the arm tip – reduce cband_spread or widen arm_w");
assert(ej_sides || z_bot < z_band - 3, "Drawer too shallow to push the ejector band – increase inner_h");
assert(pocket_x0 > wall + 5, "inner_d too small for the latch pocket");
assert(x_cam0 > 8, "inner_d too small for the latch groove");
assert(x_cam0 + U + r_eff < Dh, "cam does not fit");
assert(ej_sides || x_post > 15, "inner_d too small for band_stroke");
assert(back_r >= wall + 0.5, "back_r must be at least wall + 0.5");
// the inner corner fill sits within back_r - wall of the back and side walls: keep it
// behind the arm's tip and clear of the back band post
assert(Dd - wall - (back_r - wall) > x_tip + 0.5 &&
       Wd/2 - wall - (back_r - wall) > abs(yb) + cpost_d/2 + spool_fl + 0.5,
       "back_r too large – the rounded back corners reach the latch arm or its band post");
assert(pocket_y1 < Wd/2 - wall - 5 && pocket_y0 > -Wd/2 + wall + 5,
       "latch pocket hits a side wall – inner_w too small or latch_y too far off-centre");
assert(latch_side == "center" || latch_side == "left" || latch_side == "right",
       "latch_side must be center, left or right");
assert(screw_y + screw_cs_r < y_li, "screw countersink overlaps the slide ledge");
assert(groove_y1 + 1 + screw_head_d/2 < screw_y && groove_y0 - 1 - screw_head_d/2 > -screw_y,
       "latch groove runs into a screw row – move latch_y toward the centre");

// ============================================================= modules
module capsule2d(a, b, r) { hull() { translate(a) circle(r); translate(b) circle(r); } }

module cam_2d(r = r_eff) {
  for (p = cam_paths) for (i = [0:len(p)-2]) capsule2d(p[i], p[i+1], r);
}

// ---- housing (use orientation: z = 0 is the desk underside)
module rail_profile() {   // right side, (y, z)
  polygon([
    [y_li, z_hbot], [y_ho, z_hbot], [y_ho, -plate_t/2], [y_hi, -plate_t/2],
    [y_hi, ledge_top(y_hi)], [y_li, ledge_top(y_li)]
  ]);
}

module band_post(x) {
  translate([x, y_post, 0]) {
    translate([0,0,z_band - 1.5]) cylinder(d = post_d, h = z_hbot - z_band + 1.5 + eps);
    // 45° flare that keeps the band on (prints fine upside down)
    translate([0,0,z_band - 3]) cylinder(d1 = post_d + 3, d2 = post_d, h = 1.5);
    translate([0,0,z_band - 4.5]) cylinder(d = post_d + 3, h = 1.5);
  }
}

module groove_cut() {
  translate([0,0,-plate_t - eps]) linear_extrude(groove_depth + eps) {
    // each segment split into short pieces so the arc correction follows it smoothly
    n = 8;
    for (p = cam_paths) for (i = [0:len(p)-2]) for (k = [0:n-1])
      capsule2d(cam2h(p[i] + (p[i+1]-p[i])*k/n), cam2h(p[i] + (p[i+1]-p[i])*(k+1)/n), r_eff);
    // mouth channel from the plate front, with a lead-in funnel
    capsule2d([-5, cam2h([0,0])[1]], cam2h([0,0]), r_eff);
    hull() { translate([-1, cam2h([0,0])[1]]) circle(r_eff + 2.5); translate([8, cam2h([0,0])[1]]) circle(r_eff); }
  }
}

module screw_holes() {
  for (sy = [-1,1], x = screw_xs) translate([x, sy*screw_y, 0]) {
    translate([0,0,-plate_t-1]) cylinder(d = screw_d, h = plate_t + 2);
    // countersink opens toward the drawer side
    translate([0,0,-plate_t - eps])
      cylinder(d1 = screw_head_d + 2*screw_recess, d2 = screw_d, h = (screw_head_d - screw_d)/2 + screw_recess);
  }
}

module plate_windows() {
  // window bands on either side of the groove strip (which runs the full plate depth)
  yw = screw_y - screw_cs_r - 4;   // outer window edge, clear of the screw countersinks
  window_band(pocket_y1 + 6, yw);
  window_band(-yw, pocket_y0 - 6);
}

module window_band(y0, y1) {
  x0 = 16;  x1 = Dh - 16;
  nx = max(1, round((x1 - x0) / window_target));
  ny = max(1, round((y1 - y0) / window_target));
  cw = (x1 - x0 - (nx-1)*window_rib) / nx;
  ch = (y1 - y0 - (ny-1)*window_rib) / ny;
  if (y1 > y0 && cw > 12 && ch > 12)
    for (i = [0:nx-1], j = [0:ny-1])
      translate([x0 + i*(cw + window_rib), y0 + j*(ch + window_rib), -plate_t - 1])
        linear_extrude(plate_t + 2) offset(r = 3) offset(delta = -3) square([cw, ch]);
}

module housing() {
  difference() {
    union() {
      translate([0, -y_ho, -plate_t]) cube([Dh, 2*y_ho, plate_t]);
      for (m = [0,1]) mirror([0, m, 0]) {
        rotate([90,0,90]) linear_extrude(Dh) rail_profile();
        band_post(ej_sides ? x_spost : x_post);
      }
    }
    groove_cut();
    screw_holes();
    if (plate_windows) plate_windows();
  }
}

// ---- drawer (use orientation, closed position)
module lip_profile(l) {
  polygon([[y_wo - eps, z_rim - lip_edge - l], [y_wo + l, z_rim - lip_edge],
           [y_wo + l, z_rim], [y_wo - eps, z_rim]]);
}

module lips() {
  for (m = [0,1]) mirror([0, m, 0]) hull() {
    rotate([90,0,90]) linear_extrude(Dd - 3) lip_profile(lip);
    // lead-in taper at the back end
    translate([Dd - eps, 0, 0]) rotate([90,0,90]) linear_extrude(eps) lip_profile(lip - 2);
  }
}

// ---- latch arm (local coords: pivot axis at the origin, arm along +x, z = 0 at its bottom)
// Prints as modelled: flat on the bed, pin up. The rounded tip is where the band bears.
module latch_arm() {
  difference() {
    hull() {
      cylinder(d = hub_d, h = arm_h);
      translate([arm_r, 0, 0]) cylinder(d = arm_w, h = arm_h);
    }
    // hub bore over the pivot post
    translate([0, 0, -1]) cylinder(d = arm_post_d + 2*arm_clr, h = arm_h + 2);
  }
  translate([arm_r, 0, arm_h - eps]) {
    cylinder(d = pin_d, h = pin_h + eps);
    cylinder(d1 = pin_d + 1.6, d2 = pin_d, h = 0.8);   // root fillet
  }
}

module latch_pocket() {   // U-shaped guard: front partition + two side walls to the back wall
  pt = 1.2;
  translate([pocket_x0, pocket_y0w, z_bot]) cube([pt, pocket_y1w - pocket_y0w, Hd]);
  // a guard wall only on sides that aren't closed off to the drawer's side wall (that wall guards instead)
  for (y = [if (pocket_y0w == pocket_y0) pocket_y0, if (pocket_y1w == pocket_y1) pocket_y1 - pt])
    translate([pocket_x0, y, z_bot]) cube([Dd - wall - pocket_x0 + eps, pt, Hd]);
}

module latch_pivot() {   // shoulder the hub sits on, and the post it turns on
  translate([x_pv, yb, z_bot]) {
    cylinder(d = arm_post_d + 3, h = z_arm - z_bot);
    cylinder(d = arm_post_d, h = z_rim - 0.8 - z_bot);
    translate([0, 0, z_rim - 0.8 - z_bot - eps]) cylinder(d1 = arm_post_d, d2 = arm_post_d - 1, h = 0.5);
  }
}

module latch_tip_support() {   // arc wall under the pin that the arm slides on, so it can't droop
  translate([x_pv, yb, z_bot]) rotate([0, 0, -phi_l - 6])
    rotate_extrude(angle = phi_l + phi_r + 12, $fn = 96)
      translate([arm_r - 1.2, 0]) square([2.4, z_arm - z_bot]);
}

// band post profile: a spool whose 45° flares above and below keep the band at arm mid-height
module band_spool_2d() {
  r = cpost_d/2;  f = spool_fl;  zt = z_tun - z_bot;
  polygon([[0, 0], [r + f, 0], [r + f, zt - 1.5 - f], [r, zt - 1.5], [r, zt + 1.5],
           [r + f, zt + 1.5 + f], [0, zt + 1.5 + f]]);
}

module band_spool(x, y) {
  translate([x, y, z_bot]) rotate_extrude($fn = 32) band_spool_2d();
}

module latch_band_posts() {
  band_spool(x_bpost, yb);                                   // behind the arm tip
  hull() for (s = [-1,1]) band_spool(x_sp, yb + s*(cband_spread/2 - cpost_d/2));   // spreader
}

module mech_floor() {   // flat-topped wedge under the mechanism, cut off where it meets the drawer floor
  x0 = pocket_x0;  x1 = Dd - wall + eps;
  intersection() {
    translate([x0, pocket_y0w, z_bot]) cube([x1 - x0, pocket_y1w - pocket_y0w, z_mf - z_bot]);
    rotate([90, 0, 0]) linear_extrude(4*Wd, center = true)
      polygon([[x0, mf_under(x0)], [x1, mf_under(x1)], [x1, z_mf], [x0, z_mf]]);
  }
}

module latch_drawer_parts() {
  if (mech_slope) {
    intersection() {   // everything stands on the wedge's flat top
      union() { latch_pocket(); latch_pivot(); latch_tip_support(); latch_band_posts(); }
      translate([pocket_x0 - 1, -2*Wd, z_mf - eps]) cube([Dd + 2 - pocket_x0, 4*Wd, z_rim - z_mf + 1]);
    }
    mech_floor();
  } else {
    latch_pocket();
    latch_pivot();
    latch_tip_support();
    latch_band_posts();
  }
}

// side-hook ejector: an arm sticking straight out of the drawer's +y side wall with a lip at its
// end. Its underside rises 45° from the wall, so it prints without support; edges the band wraps
// are chamfered. Mirrored for the other side.
module side_hook() {
  c = 1.2;
  // thin slice of the hook at y (0.3 thick), spanning z0..z1, chamfered corners
  module slice(y, z0, z1) {
    x0 = x_sh - sh_w/2;  x1 = x_sh + sh_w/2;
    translate([0, y + 0.3, 0]) rotate([90, 0, 0]) linear_extrude(0.3)
      polygon([[x0, z0 + c], [x0 + c, z0], [x1 - c, z0], [x1, z0 + c],
               [x1, z1 - c], [x1 - c, z1], [x0 + c, z1], [x0, z1 - c]]);
  }
  y_end = y_wo + sh_len;
  intersection() {
    union() {
      hull() {   // arm
        slice(y_wo - 0.5, z_sht - sh_ht - (sh_len + 0.2), z_sht);
        slice(y_end - 0.3, z_sht - sh_ht, z_sht);
      }
      hull() {   // lip
        slice(y_end - sh_lt, z_sht - sh_ht, z_sht + sh_lip);
        slice(y_end - 0.3, z_sht - sh_ht, z_sht + sh_lip);
      }
    }
    translate([x_sh - sh_w, 0, z_bot]) cube([2*sh_w, Wd, -z_bot]);   // nothing below the floor
  }
}

module dividers() {
  if (dividers > 0) for (i = [1:dividers]) {
    y = -Wd/2 + wall + i * in_w / (dividers + 1);
    x1 = (y > pocket_y0w - 1 && y < pocket_y1w + 1) ? pocket_x0 : Dd - wall;
    translate([wall - eps, y - 0.6, z_bot]) cube([x1 - wall + 2*eps, 1.2, Hd - 5]);
  }
}

// box from x0 to x0+dx, centred on y = 0, with its two back (+x) vertical corners rounded
module back_rounded_box(x0, dx, dy, h, r) {
  hull() {
    translate([x0, -dy/2, 0]) cube([dx - r, dy, h]);
    for (s = [-1,1]) translate([x0 + dx - r, s*(dy/2 - r), 0]) cylinder(r = r, h = h);
  }
}

module drawer() {
  r_in = back_r - wall;                                // inner corner keeps the wall 'wall' thick
  difference() {
    union() {
      translate([0, 0, z_bot]) back_rounded_box(0, Dd, Wd, Hd, back_r);
      lips();
      // front panel – also the closing stop against the housing face
      translate([-panel_t, -(y_ho + panel_margin), z_bot])
        cube([panel_t + eps, 2*(y_ho + panel_margin), -panel_top_gap - z_bot]);
    }
    translate([0, 0, z_bot + floor_t]) back_rounded_box(wall, Dd - 2*wall, Wd - 2*wall, Hd, r_in);
  }
  latch_drawer_parts();
  dividers();
  if (ej_sides) for (m = [0,1]) mirror([0, m, 0]) side_hook();
  else for (m = [0,1]) mirror([0, m, 0]) back_loop();
}

// back band loop: a tunnel on the back wall that the band is fed through, so it stays with the
// drawer. A rounded C against the wall; where a curve would overhang it runs at 45° instead
// (the underside into the wall, the tunnel's roof up to a short flat), so it prints without support.
module back_loop() {
  ri = bl_r;  ro = bl_r + 1.4;  s = sqrt(2);
  zc = max(z_band, z_bot + ri + 1.6);   // raised on short drawers so the bottom of the C stays whole
  intersection() {
    translate([0, y_bl + bl_w/2, 0]) rotate([90, 0, 0]) linear_extrude(bl_w)
      difference() {
        // rounded outside, flat against the wall; the underside runs into the wall at 45°
        intersection() {
          hull() { translate([Dd, zc]) circle(ro); translate([Dd, zc - ro*s]) square(0.01, center = true); }
          translate([Dd - 0.5, zc - 2*ro]) square([ro + 1, 4*ro]);
        }
        // rounded inside; the roof runs up at 45° and is cut flat at the arc's height (a ~1.2 mm
        // bridge next to the wall), so it prints without support and the top stays 1.4 mm thick
        intersection() {
          hull() { translate([Dd, zc]) circle(ri); translate([Dd, zc + ri*s]) square(0.01, center = true);
                   translate([Dd - 1, zc - ri]) square([0.01, ri*(1 + s)]); }
          translate([Dd - 2, zc - ri - 1]) square([ri + 3, 2*ri + 1]);
        }
      }
    translate([Dd - 2, -Wd/2, z_bot]) cube([ro + 3, Wd, -z_bot]);   // nothing below the floor
  }
}

// ---- all parts in print orientation, side by side on the bed
module print_layout() {
  gap = 10;
  hw_h = y_ho + 1.5;                                   // housing half-width (incl. band-post flares)
  hw_d = max(y_ho + panel_margin, y_wo + lip);         // drawer half-width (front panel / lips)
  rotate([180,0,0]) housing();                         // desk face down
  translate([0, -(hw_h + gap + hw_d), -z_bot]) drawer();        // floor down
  translate([hub_d/2, -(hw_h + gap + 2*hw_d + gap + hub_d/2), 0]) latch_arm();   // pin up
}

// ============================================================= output
// F6 (full render) of the assembly gives the print layout; F5 preview shows it assembled.
if (part == "print_layout" || (part == "assembly" && !$preview)) print_layout();
else if (part == "assembly") {
  color("SteelBlue", 0.85) housing();
  translate([-assembly_open, 0, 0]) {
    color("Orange") drawer();
    color("Crimson") translate([x_pv, yb, z_arm]) latch_arm();
    // latch centring band (two strands from the spreader past the arm tip to the back post, at rest)
    color("Black") for (s = [-1,1]) {
      pts = [[x_sp, yb + s*(cband_spread/2 + 0.5)], [x_pin, yb + s*(arm_w/2 + 0.5)],
             [x_bpost, yb + s*(cpost_d/2 + 0.5)]];
      for (i = [0:1]) hull() for (p = [pts[i], pts[i+1]]) translate([p[0], p[1], z_tun]) sphere(d = 1, $fn = 8);
    }
  }
  // ejector rubber band(s): the back band shown relaxed, the side bands between post and hook
  color("Black") for (m=[0,1]) mirror([0,m,0])
    if (ej_sides) for (s = [-1,1])
      hull() {
        translate([x_spost, y_post + s*(post_d/2 + 0.5), z_band]) sphere(d = 1, $fn = 8);
        translate([x_sh - assembly_open, y_sh, z_sh + s*(sh_ht/2 + 0.5)]) sphere(d = 1, $fn = 8);
      }
    else translate([x_post - post_d/2 - 0.5, 0, z_band]) rotate([90,0,0]) cylinder(d = 1, h = y_post);
}
else if (part == "housing") rotate([180,0,0]) housing();   // desk face down on the bed
else if (part == "drawer")  translate([0,0,-z_bot]) drawer();
else if (part == "arm")     latch_arm();                    // flat on the bed, pin up
else if (part == "cam_2d")  cam_2d();
else if (part == "cam_paths") {
  // machine-readable dump for the latch simulator
  echo(str("CAM r_eff=", r_eff, " pin_r=", pin_d/2, " u_stop=", u_stop, " U=", U, " u_a=", u_a));
  echo(str("ARM r=", arm_r, " rest=", cam_rest_v));
  for (p = cam_paths) echo(str("PATH ", p));
  cube(1);
}
