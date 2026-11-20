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
//            Wide ones: a kicker, a short band on two posts beside the latch pocket
//            that the pocket's back pushes into (picked automatically).
//
//  Hardware: countersunk wood screws (default #8 / 4 mm; 4 on small drawers, more
//            on long ones – see screw_spacing), two rubber bands.
// =====================================================================

/* [Output] */
// assembly: F5 shows it assembled, F6 renders all parts laid out for printing
// animation: F5 with Window > Animate open (View > Animate in 2021) runs one push-push cycle per loop;
// set e.g. FPS 15 and Steps 100 (more for deep drawers)
part = "assembly"; // [assembly, animation, energy_map, print_layout, housing, drawer, arm, cam_2d, cam_paths]
// Assembly view: how far the drawer is pulled out (100% = all but 15 mm out of the housing)
assembly_open_pct = 0; // [0:1:100]
// Animation view, drawer: "solid", or "ghost" (see-through grey, shows the bands behind it).
// The housing is shown as just an outline of its latch groove and its band posts, so nothing hides the arm.
animation_drawer = "solid"; // [solid, ghost]
// Debug: engrave each part with the git commit it came from and its part number
// (1 = housing, 2 = drawer, 3 = arm), e.g. "2e161e2-2". A "+" after the hash means the
// file had uncommitted changes. The hash comes from version.scad (see README).
debug_stamp = false;

/* [Drawer interior (mm)] */
// Minimums are the smallest sizes that work with defaults for everything else:
// width – the latch arm's swing; depth – the latch arm and its band (spreader to back post);
// height – drawer must reach below the ejector band.
// Defaults are the minimums – a small, quick test print.
inner_w = 47;  // [47:0.1:500]
inner_d = 62;  // [62:0.1:500]
inner_h = 17;  // [17:0.1:300]
// Number of lengthwise dividers (0 = none)
dividers = 0;

/* [Drawer walls] */
wall = 2; // [1:0.1:6]
floor_t = 1.6; // [0.8:0.1:5]
panel_t = 4; // [1:0.1:15]
// Extra front-panel width beyond the housing on each side
panel_margin = 0; // [0:0.1:30]
// Gap between front-panel top edge and the desk
panel_top_gap = 1; // [0:0.1:5]

/* [Slide] */
// Size of the 45° lip on each side of the drawer
lip = 5; // [2:0.1:10]
// Small vertical flat on the lip tip
lip_edge = 1.5; // [0:0.1:4]
// Gap across the 45° sliding faces (perpendicular)
slide_clr = 0.35; // [0:0.05:1.5]
// Gap between lip tip and housing wall
side_clr = 0.6; // [0:0.05:2]
// Gap between drawer rim and housing plate
top_gap = 1; // [0:0.1:4]
// Material under the ledge's 45° face at its thinnest
ledge_min = 3; // [1:0.1:8]
housing_wall = 3; // [1.2:0.1:8]
plate_t = 5; // [3:0.1:12]

/* [Desk screws] */
// Countersunk wood screw size (US gauge / metric equivalent)
screw = 4; // [3.5:#6 / 3.5 mm, 4:#8 / 4 mm, 4.5:#9 / 4.5 mm, 5:#10 / 5 mm]
// Most space allowed between screws along each side. Each side gets as many as
// that needs (never fewer than 2), so small drawers use 4 screws and longer ones more.
screw_spacing = 100; // [40:0.1:200]

/* [Push latch] */
// Where the latch track (in the housing) and its mechanism (in the drawer) go, seen from the
// front. left / right put them as close to that side as fits (clear of the side wall, the
// screws and the rounded back corner), leaving one big open area in the drawer.
latch_side = "center"; // [center, left, right]
// Extra sideways shift of the latch, mm (+ = toward the left). Added to the centre or side position.
latch_y = 0; // [-100:0.1:100]
pin_d = 3; // [2:0.1:6]
// Radial clearance between pin and groove
pin_clr = 0.35; // [0:0.05:1]
// Minimum printed wall between groove branches
cam_wall_min = 1.6; // [0.8:0.1:4]
groove_depth = 3.4; // [1.5:0.1:6]
// Pin protrusion above the drawer rim
pin_h = 3.2; // [1:0.1:6]
// How far short of the groove end the panel stops the drawer
stop_back = 1.2; // [0.3:0.1:3]

/* [Latch arm] */
// Rigid arm (separate part) that carries the pin. It swings sideways on a post
// at its front end, so it can't jam or tip like a slider. The groove is
// corrected for the arc the pin travels.
// Pivot to pin
arm_r = 26; // [15:0.1:60]
// Width at the tip
arm_w = 8; // [5:0.1:16]
arm_h = 7; // [3:0.1:15]
// Radial clearance between the arm's hub and its pivot post
arm_clr = 0.2; // [0:0.05:1]
arm_post_d = 5; // [3:0.1:10]
// Centring band: one band stretched lengthwise around a spreader in front of the
// arm's hub and a post behind its tip. The arm sits between the two strands; when
// it swings, its tip pushes one strand out like a bowstring. Nothing to thread,
// and a doubled band works too.
// Arm tip end to the back post
cband_back = 8; // [4:0.1:20]
// Spreader width (strand spacing at the front)
cband_spread = 13; // [6:0.1:30]
cpost_d = 4; // [2:0.1:8]
// Deep drawers: instead of standing on the drawer floor, the latch mechanism sits on a
// flat floor just under the arm (so its posts stay short and stiff), carried by a solid
// wedge whose underside slopes 45° down to the back wall (prints without support). The
// space under it is usable. Used when that leaves at least this much height under the
// pocket's front edge (0 = whenever possible, 300 = never).
mech_slope_min = 10; // [0:0.1:300]

/* [Rubber band ejector] */
// Picked automatically (the console says which and why). Small drawers: one band across the
// back of the drawer, which gets longer as the drawer gets wider; it also catches the drawer.
// Once that band would need a flat length over 96 mm: a kicker instead, a short band on two posts
// hanging from the housing either side of the latch pocket, which the back of the pocket pushes
// into as the drawer closes. It never leaves its posts and never touches anything that moves away,
// so it can't fall off, but nothing catches the drawer after it lets go: friction stops it.
// How far it pushes (back band: it is stretched this much as the drawer closes). Raised to what the
// latch needs (the pin has to leave its groove) if lower.
band_stroke = 32; // [10:0.1:80]
// Kicker: strength of the band you'll use (the pull, N, that stretches it to twice its length;
// 1/16" wide is about 2 N, 1/8" about 4 N). The console picks the band length that suits it for
// this drawer's weight, so the drawer opens about twice the stroke empty and isn't thrown out.
kicker_band_n = 4; // [1:0.1:20]
post_d = 6; // [3:0.1:12]
// Band height below the housing bottom
band_drop = 6; // [2:0.1:20]
// Back band: radius of the drawer's two back corners, where the band wraps (sharp corners cut it).
// Kicker drawers have square back corners: their band never touches them.
back_r = 6; // [3:0.1:12]

/* [Energy map] */
// Only for part = energy_map (a console printout of the bands' stored energy through one cycle).
// Band strength: the pull (N) it takes to stretch one band to twice its relaxed length (hang a
// weight on it: 100 g is about 1 N). Rough guide: 1/16" wide about 2 N, 1/8" about 4 N, 1/4" about 8 N.
latch_band_n = 2; // [0.5:0.1:20]
// back band only; the kicker uses kicker_band_n (Rubber band ejector)
ejector_band_n = 6; // [0.5:0.1:40]

/* [Plate lightening] */
plate_windows = true;
window_rib = 8; // [3:0.1:20]
window_target = 40; // [15:0.1:100]

/* [Hidden] */
// version.scad (not committed) holds git_sha; tools/write_version.sh writes it, and the git hooks
// in tools/githooks rerun that on every commit, checkout and merge. -D git_sha="..." overrides it.
include <version.scad>
stamp_sha = is_undef(git_sha) ? "nogit" : git_sha;
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
// about 36° off straight, so the pin gets pushed across gradually.
// Pushing the arm across stretches the latch band, and the ejector has to supply that while it
// is itself running out of push. So the curve starts soon after P3 reaches the exit column and is
// skewed (p4_skew) to do most of its swing early, when the ejector is still pushing hard, and
// flatten out where the band is stretched most. Past the left channel the band gives the energy
// back: the last diagonal to the mouth lets it push the pin, and so the drawer, outward.
p4_e = 2.3;  p4_skew = 0.4;
u_4e = abs(v_l) + p4_e;                       // reaches the left channel here...
u_4s = u_D + 0.1;                              // ...having started to turn just after P3 ends (a later
                                              // start puts the wedge between P3 and P4 in a rest-offset pin's way)
p4_len = u_4s - u_4e;
p4_curve = [for (i = [0:24]) let(t = i/24, h = t + p4_skew*t*(1 - t))
  [u_4s - p4_len*t, v_le - (v_le - v_l)*(0.5 - 0.5*cos(180*h))]];
u_stop = U - stop_back;           // pin position when panel hits housing

// Bounce margin: on the way out after push 1 the band pulls the pin toward the exit side,
// and with momentum (arm swing, drawer bounce, pivot play – worse when the drawer isn't
// level and nothing damps the arm) it can cut over to the exit. P2 drops straight first so
// it reaches the exit diagonal (P3) low, and P3 climbs to above u_D: the drawer would have
// to move back in ~2.3 mm mid-return to skip the catch (tools/cammargin.ps1; was 0.66, 2.1 before
// the corners were rounded).
// Smooth corners: like the heart cams in the prior art, the pin's path has no kinks except where
// it must: the ends of each path, which are where paths meet and so form the island's cusps (the
// notch seat, the stroke ends, the mouth). A kink jerks the rigid arm sideways all at once and
// friction can turn that into a stall (the old 45° corner on P4 made the drawer stutter); worse,
// on the inside of a bend tighter than r_eff the groove wall is a sharp corner whatever the path
// does. So every corner [u, v, radius] is rounded by a circular arc of that radius, tangent to
// both legs, and no wall gets steeper than the straight legs it replaces. Radii are smaller where
// a stroke end has to be reached before the panel stop (-0.8 mm tolerance) or the leg is short.
function arc_pts(B, ea, ec, R) = let(
    th = 180 - acos(max(-1, min(1, ea*ec))),          // turn angle
    t = R*tan(th/2), p0 = B + ea*t, p2 = B + ec*t,
    O = B + (ea + ec)/norm(ea + ec) * R/cos(th/2), w0 = p0 - O, w2 = p2 - O, n = max(2, ceil(th/5)))
  th < 0.5 ? [B] : [for (k = [0:n]) let(s = k/n) O + (sin((1-s)*th)*w0 + sin(s*th)*w2)/sin(th)];
function fillet_back(S, i) = let(A = [S[i-1][0], S[i-1][1]], B = [S[i][0], S[i][1]], C = [S[i+1][0], S[i+1][1]],
    ea = (A - B)/norm(A - B), ec = (C - B)/norm(C - B)) S[i][2]*tan((180 - acos(max(-1, min(1, ea*ec))))/2);
function fillet_path(S) = let(n = len(S)) [for (i = [0:n-1]) each
  (i == 0 || i == n-1) ? [[S[i][0], S[i][1]]] :
  let(A = [S[i-1][0], S[i-1][1]], B = [S[i][0], S[i][1]], C = [S[i+1][0], S[i+1][1]])
  arc_pts(B, (A - B)/norm(A - B), (C - B)/norm(C - B), S[i][2])];
// the arcs on each leg must fit inside it
function fillet_fits(S) = min([for (i = [0:len(S)-2])
  norm([S[i+1][0] - S[i][0], S[i+1][1] - S[i][1]]) - (i > 0 ? fillet_back(S, i) : 0) - (i+1 < len(S)-1 ? fillet_back(S, i+1) : 0)]) >= 0;
// The right channel's top is one arc where the ramp meets the diagonal down to the stroke-1 end
// (the 0.5 mm flat between them is too short to round each corner on its own). Its peak stays
// below v_rc, which is kept as the channel's limit for the arm's swing room.
function line_meet(P, d, Q, e) = let(t = ((Q[0]-P[0])*e[1] - (Q[1]-P[1])*e[0]) / (d[0]*e[1] - d[1]*e[0])) P + d*t;
p1_top = line_meet([u_1, 0], [u_2 - u_1, v_rc], [u_D, v_tr], [u_C - u_D, v_rc - v_tr]);
cam_spec = [
  // P1: entry straight, ramp, right channel, over to stroke-1 end
  [[0,0],[u_1,0,3],[p1_top[0],p1_top[1],2],[u_D,v_tr,2],[U,v_tr]],
  // P2: drop straight from stroke-1 end, then over into the notch
  [[u_D,v_tr],[u_D-u_drop,v_tr,2],[u_a+0.6,v_n,1.4],[u_a,v_n]],
  // P3: notch straight up (from latched, a 4 mm push still re-latches; ~5 mm releases), then forced left to stroke-2 end
  [[u_a,v_n],[u_a+2.8,v_n,2.5],[u_D+0.5,v_le,2],[U,v_le]],
  // P4 tail: from the S-curve's end along the left channel and diagonally back to the mouth
  [[u_4e,v_l],[abs(v_l),v_l,3],[0,0]]
];
for (S = cam_spec) assert(fillet_fits(S), str("corner arcs overlap on cam path ", S));
p4_tail = fillet_path(cam_spec[3]);
cam_paths = [
  fillet_path(cam_spec[0]), fillet_path(cam_spec[1]), fillet_path(cam_spec[2]),
  // P4: exit around the left of the island back to the mouth, on a smooth S-curve
  concat([[U,v_le]], p4_curve, [for (i = [1:len(p4_tail)-1]) p4_tail[i]])
];
// tightest bend inside any path (the ends are the cusps), as the radius through three neighbouring
// points, for the cam_paths dump
function circ_r(a, b, c) = let(x = norm(b - a), y = norm(c - b), z = norm(c - a),
  k = abs((b - a)[0]*(c - a)[1] - (b - a)[1]*(c - a)[0])) k < 1e-9 ? 1e9 : x*y*z/(2*k);
cam_min_r = min([for (P = cam_paths) for (i = [1:len(P)-2]) circ_r(P[i-1], P[i], P[i+1])]);

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
// The ejector also has to carry the pin out of the latch groove. The drawer only runs by itself
// while the bands' total stored energy keeps falling (part = energy_map prints it), and the
// ejector's lowest point is where it is relaxed: if that comes before the pin has left the groove
// (u_stop mm out), the drawer stops with the pin still on the exit path, not reset for the next
// close, and past it the band stretches the other way, uphill. So the stroke is at least ej_need,
// 5 mm past the groove mouth, so the band is still pushing there. On the shortest drawers that
// beats the 15 mm rule, and the worst-case overshoot then keeps only 4 mm of the drawer on its ledges.
ej_free = u_stop - abs(v_l);       // the latch band resists until here (the left channel's end), then helps
ej_need = ceil(u_stop) + 5;
bb_stroke = min(band_stroke, max(floor((Dd - 15)/2), min(ej_need, floor((Dd - 4)/2))));
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

// kicker (wide drawers): a back band has to span the full width, so on a wide drawer it is long
// and barely stretched. The kicker uses a short band instead, whatever the width: it stays on two
// posts hanging from the housing, one each side of the latch pocket, always a little stretched
// (k_pre), so it is never slack and has nothing to fall off. It is never attached to the drawer:
// over the last k_s mm of closing the back of the latch pocket (the "nose") pushes the middle of
// the band back into a V, and released, the band pushes it out again and lets go. Each post runs
// in a notch cut into the top of the drawer's back, inside a small walled bay so nothing in the
// drawer gets in its way.
// Nothing catches the drawer after the band lets go: friction stops it. So the band has to be weak
// enough not to throw it out, and the console suggests a strength for the drawer's weight.
kp_d = post_d;                 // post shaft where the band sits
kp_f = 1.5;                    // 45° flare (radius added) above and below the band
kp_r = kp_d/2 + kp_f;          // post's widest radius
kp_clr = 1;                    // post to drawer clearance
k_bw = 1.2;                    // bay wall thickness
k_rc = 2;                      // nose corners rounded, where the band wraps them
z_kb = z_rim - 3;              // band height: 3 mm under the rim
z_kbot = z_kb - 1.5 - kp_f - 1.5;   // post's bottom
z_knb = z_kbot - kp_clr;       // notch floor
k_s = max(band_stroke, ej_need);   // stroke: still pushing when the pin leaves the groove
x_kp = Dd - k_s + kp_d/2;      // posts: the band's front strand touches the nose k_s out
yk = (pocket_y0 + pocket_y1)/2;    // centred on the latch pocket, so it pushes straight on the latch
k_n = (pocket_y1 - pocket_y0)/2;   // half-width of the nose (the pocket's outer faces)
k_pre = 1.2;                   // the band's stretch when the drawer is open
// band loop length with the nose at x = X (drawer's back), posts yk +- a: both strands (front and
// rear of the posts) run straight across until the nose reaches them, then post -> nose corner ->
// other corner -> other post
function k_len(X, a) = PI*kp_d + sum([for (xj = [x_kp - kp_d/2, x_kp + kp_d/2])
  X > xj ? 2*k_n + 2*norm([a - k_n, X - xj]) : 2*a]);
k_amin = k_n + kp_r + kp_clr + 0.3;                       // post track clear of the pocket wall
k_ylim = min(Wd/2 - wall - k_bw - kp_r - kp_clr,           // bay inside the drawer's side wall
             lat_screw_y - screw_head_d/2 - screw_recess - 1 - kp_r);   // post clear of the countersinks

// Nothing catches the drawer once the kicker lets go, so the band is sized for the drawer's weight.
// Rough weight: PLA ~1.24 g/cm³, walls printed solid. The drawer hangs on 45° ledges, which presses
// them with sqrt(2) x its weight; PLA on PLA ~0.3.
d_mass = 1.24e-3 * (Wd*Dd*floor_t + 2*(Wd + Dd)*wall*in_h + 2*(y_ho + panel_margin)*(-panel_top_gap - z_bot)*panel_t
                    + 2*Dd*(lip*lip/2 + lip*lip_edge));   // g
k_mu = 0.3;
function fric(g) = k_mu * sqrt(2) * g * 9.81e-3;    // N, for a drawer + contents of g grams
// what the latch band takes back on the way out: the hill from released to the arm's furthest swing
k_hill = max(0, band_e(latch_band_n, el_len(v_l - cam_rest_v), cband_loop/1.5) - band_e(latch_band_n, el_len(v_le - cam_rest_v), cband_loop/1.5));
// energy a band of flat length L on posts yk +- a gives per N of strength (mJ/N), closed to letting go
function k_e1_of(L, a) = band_e(1, k_len(Dd, a), 2*L) - band_e(1, k_len(0, a), 2*L);
// the strength that gives twice what an empty drawer needs to get to the end of the stroke, so it
// coasts about one more stroke; heavier drawers coast less
function k_nrec_of(L, a) = 2*(fric(d_mass)*k_s + k_hill) / k_e1_of(L, a);
// 1/2" band sizes, 1.5" to 6": posts spaced for k_pre, keep the ones that fit and stretch at most
// 2.5x closed. A longer band sits on posts further apart and is stretched less, so it gives less
// energy for its strength: pick the length whose suggested strength is nearest kicker_band_n.
k_cands = [for (k = [3:12]) let(L = k*12.7, a = (k_pre*2*L - PI*kp_d)/4)
  if (a >= k_amin && abs(yk) + a <= k_ylim && k_len(Dd, a) / (2*L) <= 2.5) [L, a, abs(ln(k_nrec_of(L, a) / kicker_band_n))]];
k_fit = len(k_cands) > 0 && z_knb > z_bot + floor_t + 2 && x_kp - kp_r - kp_clr - k_bw > pocket_x0;
k_best = k_fit ? min([for (c = k_cands) c[2]]) : 0;
k_pick = k_fit ? [for (c = k_cands) if (c[2] <= k_best + 1e-9) c][0] : [38.1, k_amin, 0];
k_band = k_pick[0];                             // flat length
k_a = k_pick[1];                                // post offset from yk
k_stretch = k_len(Dd, k_a) / (2*k_band);
k_e1 = k_e1_of(k_band, k_a);
k_n_rec = k_nrec_of(k_band, k_a);
k_want = back_band_len > 96;
// a light drawer with little room beside the pocket would want a band too weak to buy (under
// 1.5 N): the back band, which also catches the drawer, is the better choice there
ej_kick = k_want && k_fit && k_n_rec >= 1.5;
ej_rest = ej_kick ? k_s : bb_stroke;            // where the ejector stops pushing
ej_open = ej_rest;                              // where the animation leaves the released drawer
function k_coast(n, g) = (n*k_e1 - k_hill - fric(g)*k_s) / fric(g);   // mm past the stroke end
function k_maxg(n) = (n*k_e1 - k_hill) / fric(1) / u_stop;            // drawer + contents (g) that still resets

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
function r1(x) = round(x*10)/10;
if (ej_kick) {
  echo(str("Ejector: kicker – 1 band of ", k_band/25.4, "\" (", round(k_band), " mm) flat length around the two posts",
           " (", round(2*k_a), " mm apart) behind the latch pocket (a back band would need ~", back_band_len,
           " mm). It stays on the posts, stretched ", k_pre, "x open and ", r1(k_stretch), "x closed, and pushes the drawer ",
           k_s, " mm, then lets go; friction stops it after that, nothing catches it"));
  let(c = k_coast(kicker_band_n, d_mass))
  echo(str("Kicker band: length picked for a ", kicker_band_n, " N band (kicker_band_n; 1/16\" wide is about 2 N, 1/8\" about 4 N)",
           " and a drawer of roughly ", round(d_mass), " g; ", r1(k_n_rec), " N would suit this length best. Rough guide",
           " (friction varies): empty, it coasts ~", round(max(0, c)), " mm past the ", k_s, " mm push (~", round(k_s + max(0, c)),
           " mm open of ", Dd, "), and it still opens far enough to reset the latch with up to ~",
           round(max(0, k_maxg(kicker_band_n) - d_mass)), " g inside. A heavier load stops it short (a pull resets it);",
           " a stronger band throws it further"));
  if (k_s + k_coast(kicker_band_n, d_mass) > Dd - 15)
    echo(str("WARNING: a ", kicker_band_n, " N kicker band can throw this empty drawer out – use a weaker one (about ",
             r1(k_n_rec), " N)"));
  if (abs(ln(k_n_rec / kicker_band_n)) > ln(1.5))
    echo(str("WARNING: no band length suits a ", kicker_band_n, " N band on this drawer; about ", r1(k_n_rec),
             " N is what the ", k_band/25.4, "\" length wants"));
}
if (!ej_kick) {
  echo(str("Ejector band: post spacing ", 2*y_post, " mm -> use a band with flat length ~",
           back_band_len, " mm (or a chain of bands). Feed it through the two loops on the drawer's back,",
           " then loop it around both posts. It also stops the drawer: released, the drawer settles about ",
           bb_stroke, " mm open, and even a strong band can't throw it out further than about ", 2*bb_stroke,
           " mm (of ", Dd, ")", bb_open25 < Dd - 15 ? str("; pulled out more than ~", round(bb_open25),
           " mm the band is stretched 2.5x") : ""));
  if (bb_stroke < band_stroke)
    echo(str("Ejector stroke cut to ", bb_stroke, " mm (band_stroke ", band_stroke,
             ") so the band can catch this short drawer"));
  if (bb_stroke < ej_need)
    echo(str("WARNING: ejector stroke ", bb_stroke, " mm is under ", ej_need,
             " mm: the band has little or no push left when the latch pin leaves its groove, so the drawer may stop",
             " short and need a pull before it latches again (part = energy_map shows it)", band_stroke < ej_need ? " (raise band_stroke)" : ""));
  if (k_want)
    echo(str(k_fit ? str("Kicker not used: this drawer is light enough that the band that fits beside the latch pocket would",
                         " have to be very weak (~", r1(k_n_rec), " N); the back band also catches the drawer")
                   : "WARNING: kicker not used (no 1.5\"-6\" band fits beside the latch pocket, or the drawer is too shallow): the back band is long and weak at this width",
             latch_side != "center" ? " (with latch_side = center the kicker has room on both sides of the pocket)" : ""));
}
echo(str("Latch centring band: loop path ", round(cband_loop), " mm -> use a band of ~",
         round(cband_loop/1.5), " mm circumference (flat length ~", round(cband_loop/3),
         " mm), or a smaller one doubled"));
assert(z_arm - 2 > z_bot + floor_t, "Drawer too shallow for the latch arm – increase inner_h");
assert(throw_r < arm_r - 8, "arm_r too short for the cam's sideways travel");
assert(x_bpost - cpost_d/2 - spool_fl - x_tip >= 1.5, "cband_back too short – band post hits the arm tip");
assert(band_y(x_pv) >= hub_d/2 + 0.4, "latch band strands rub the arm's hub – increase cband_spread");
assert(band_y(x_pin) <= arm_w/2 - 0.4, "latch band strands don't press on the arm tip – reduce cband_spread or widen arm_w");
assert(ej_kick || z_bot < z_band - 3, "Drawer too shallow to push the ejector band – increase inner_h");
assert(pocket_x0 > wall + 5, "inner_d too small for the latch pocket");
assert(x_cam0 > 8, "inner_d too small for the latch groove");
assert(x_cam0 + U + r_eff < Dh, "cam does not fit");
assert(ej_kick || x_post > 15, "inner_d too small for band_stroke");
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
assert(!ej_kick || (yk + k_a - kp_r > groove_y1 + 1 && yk - k_a + kp_r < groove_y0 - 1),
       "kicker posts run into the latch groove");

// ============================================================= modules
// ---- debug stamp: "<commit>-<part number>" engraved stamp_d deep. stamp_cut() is a cutting body
// with the text's face at z = 0, reading along +x, centred, sized to fit L long and at most H tall.
stamp_d = 0.5;
function stamp_label(n) = str(stamp_sha, "-", n);
module stamp_cut(n, L, H) {
  s = stamp_label(n);
  translate([0, 0, -stamp_d]) linear_extrude(stamp_d + 1)
    text(s, size = min(H, L / (0.76*len(s))), font = "Liberation Sans:style=Bold",
         halign = "center", valign = "center");
}

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

// kicker post: hangs from the plate, with a 45° flare above and below the band so it stays at
// z_kb (above it, so it can't ride up over the drawer's rim). Every face is 45° or flatter when
// the housing prints upside down.
module kick_post(y) {
  zt = z_kb + 1.5 + kp_f;  zb = z_kb - 1.5 - kp_f;
  translate([x_kp, y, 0]) {
    translate([0, 0, zt - eps]) cylinder(r = kp_r, h = -plate_t - zt + 2*eps);
    translate([0, 0, z_kb + 1.5]) cylinder(r1 = kp_d/2, r2 = kp_r, h = kp_f);
    translate([0, 0, z_kb - 1.5 - eps]) cylinder(d = kp_d, h = 3 + 2*eps);
    translate([0, 0, zb]) cylinder(r1 = kp_r, r2 = kp_d/2, h = kp_f);
    translate([0, 0, z_kbot]) cylinder(r = kp_r, h = zb - z_kbot + eps);
  }
}
module kick_posts() { for (s = [-1, 1]) kick_post(yk + s*k_a); }

module groove_cut() {
  translate([0,0,-plate_t - eps]) linear_extrude(groove_depth + eps) groove_2d();
}

module groove_2d() {   // the groove's outline in housing x/y
  {
    // each segment split into pieces of at most 1 mm so the arc correction follows it smoothly
    function pieces(a, b) = max(1, ceil(norm(b - a)));
    for (p = cam_paths) for (i = [0:len(p)-2]) let(n = pieces(p[i], p[i+1])) for (k = [0:n-1])
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

hb_lim = screw_y - screw_cs_r - 1;              // inside the countersinks
hb_fy = cam2h([0, 0])[1];                       // mouth funnel centre line
hb_seg = (hb_fy - 5.5 + hb_lim) >= (hb_lim - hb_fy - 5.5) ? [-hb_lim, hb_fy - 5.5] : [hb_fy + 5.5, hb_lim];
hb_stamp_L = hb_seg[1] - hb_seg[0] - 2;
hb_stamp_y = (hb_seg[0] + hb_seg[1]) / 2;
module housing() {
  difference() {
    union() {
      translate([0, -y_ho, -plate_t]) cube([Dh, 2*y_ho, plate_t]);
      for (m = [0,1]) mirror([0, m, 0]) {
        rotate([90,0,90]) linear_extrude(Dh) rail_profile();
        if (!ej_kick) band_post(x_post);
      }
      if (ej_kick) kick_posts();
    }
    groove_cut();
    screw_holes();
    // the kicker posts stand on solid plate: no window within 3 mm of them
    if (plate_windows) difference() {
      plate_windows();
      if (ej_kick) for (s = [-1, 1]) translate([x_kp, yk + s*k_a, -plate_t - 2]) cylinder(r = kp_r + 3, h = plate_t + 4);
    }
    // left outer face, reading from outside (back to front), mid-height
    if (debug_stamp) translate([Dh/2, y_ho, z_hbot/2]) multmatrix([[-1,0,0,0],[0,0,1,0],[0,1,0,0],[0,0,0,1]])
      stamp_cut(1, Dh - 16, min(5, -z_hbot - 4));
    // and on the plate's underside along the solid front strip (x < 10, in front of the screws'
    // countersinks and the windows), on the wider side of the groove's mouth funnel
    // (left off when it would be under 2.4 mm tall: narrow drawers)
    if (debug_stamp && hb_stamp_L / (0.76*len(stamp_label(1))) >= 2.4)
      translate([7, hb_stamp_y, -plate_t]) rotate([0, 0, 90]) rotate([180, 0, 0]) stamp_cut(1, hb_stamp_L, 4.5);
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
    // top face, between the hub bore and the pin
    if (debug_stamp) let(x0 = arm_post_d/2 + arm_clr + 1, x1 = arm_r - pin_d/2 - 0.8 - 1)
      translate([(x0 + x1)/2, 0, arm_h]) stamp_cut(3, x1 - x0, min(3.5, arm_w - 3));
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

// kicker, drawer side. The notch: where the posts run (from x_kp out through the back wall) and
// where the band's strands run from them to the nose corners when closed, plus everything behind the
// drawer, with the nose corners rounded (k_rc) where the band wraps them. Cut from just under the
// posts' bottom up through the rim.
module kick_cut_2d() {
  rp = kp_r + kp_clr;
  offset(r = -k_rc) offset(r = k_rc) union() {
    for (s = [-1, 1]) hull() {
      translate([x_kp, yk + s*k_a]) circle(r = rp);
      translate([Dd + 3, yk + s*k_a]) circle(r = rp);
      translate([Dd, yk + s*k_n]) square(eps, center = true);
      translate([Dd + 3, yk + s*k_n]) square(eps, center = true);
    }
    translate([Dd, yk - k_a - rp]) square([10, 2*(k_a + rp)]);
  }
}
module kick_notch() { translate([0, 0, z_knb]) linear_extrude(z_rim - z_knb + 1) kick_cut_2d(); }
// the bays: a front wall and an outer wall around each post's notch, full height, so nothing in
// the drawer sits where the posts go (the pocket's side wall and the back wall close them off)
module kick_bays() {
  rp = kp_r + kp_clr;
  xf = x_kp - rp - k_bw;
  for (s = [-1, 1]) let(y0 = yk + s*k_n, y1 = yk + s*(k_a + rp + k_bw)) {
    translate([xf, min(y0, y1), z_bot]) cube([k_bw, abs(y1 - y0), Hd]);
    translate([xf, min(y1, y1 - s*k_bw), z_bot]) cube([Dd - wall - xf + eps, k_bw, Hd]);
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
// (square when r = 0)
module back_rounded_box(x0, dx, dy, h, r) {
  if (r <= 0) translate([x0, -dy/2, 0]) cube([dx, dy, h]);
  else hull() {
    translate([x0, -dy/2, 0]) cube([dx - r, dy, h]);
    for (s = [-1,1]) translate([x0 + dx - r, s*(dy/2 - r), 0]) cylinder(r = r, h = h);
  }
}

// the back corners are rounded only for the back band, which wraps them; the kicker's band never
// touches them, so a kicker drawer has square corners (and a little more room)
d_back_r = ej_kick ? 0 : back_r;

module drawer() {
  r_in = max(0, d_back_r - wall);                      // inner corner keeps the wall 'wall' thick
  difference() {
    union() {
      difference() {
        union() {
          translate([0, 0, z_bot]) back_rounded_box(0, Dd, Wd, Hd, d_back_r);
          lips();
          // front panel – also the closing stop against the housing face
          translate([-panel_t, -(y_ho + panel_margin), z_bot])
            cube([panel_t + eps, 2*(y_ho + panel_margin), -panel_top_gap - z_bot]);
        }
        translate([0, 0, z_bot + floor_t]) back_rounded_box(wall, Dd - 2*wall, Wd - 2*wall, Hd, r_in);
        // underside (the bed face), reading from below
        if (debug_stamp) translate([Dd/2, 0, z_bot]) rotate([180, 0, 0]) stamp_cut(2, Dd - 16, min(6, Wd/4));
      }
      latch_drawer_parts();
      dividers();
      if (ej_kick) kick_bays();
      else for (m = [0,1]) mirror([0, m, 0]) back_loop();
    }
    if (ej_kick) kick_notch();   // also cuts any divider that crosses a post's path
  }
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
if (debug_stamp) echo(str("Debug stamp: housing ", stamp_label(1), ", drawer ", stamp_label(2), ", arm ", stamp_label(3),
  stamp_sha == "nogit" ? " – WARNING: no version.scad, run tools/write_version.sh (see README)" : ""));
// F6 (full render) of the assembly gives the print layout; F5 preview shows it assembled.
// The pin is placed at cam position (u, v): u = u_stop - how far the drawer is out (negative once
// the pin has left the plate), v = its sideways position, which sets the arm's swing.
// lateral position v at depth u along a cam path that runs one way in u (clamped to its ends)
function path_v(P, u) = let(
  Q = P[len(P)-1][0] > P[0][0] ? P : [for (i = [len(P)-1:-1:0]) P[i]],
  uu = max(Q[0][0], min(Q[len(Q)-1][0], u)),
  i = max([for (k = [0:len(Q)-2]) if (Q[k][0] <= uu) k]),
  a = Q[i], b = Q[i+1])
  b[0] > a[0] ? a[1] + (b[1] - a[1]) * (uu - a[0]) / (b[0] - a[0]) : b[1];
// out of the plate the latch band brings the pin back to rest over the funnel's ~4 mm
function v_free(u) = cam_rest_v * min(1, -u / 4);
function v_exit(u)  = u >= 0 ? path_v(cam_paths[3], u) : v_free(u);   // going out (after release)
function v_entry(u) = u >= 0 ? path_v(cam_paths[0], u) : v_free(u);   // going in
// Animation, one push-push cycle per run of $t: latched (pause) -> push -> released, out along the
// exit path to where the ejector leaves it (ej_open; pause) -> in along the entry path to the stop ->
// let go, back into the notch.
// Phase lengths are in mm of travel (pauses as 12 mm), so the drawer moves at a steady pace.
an_umin = u_stop - ej_open;
an_d = [12, u_stop - u_a, u_stop - an_umin, 12, u_stop - an_umin, u_stop - u_a];
an_tot = an_d[0] + an_d[1] + an_d[2] + an_d[3] + an_d[4] + an_d[5];
function an_phase(T, k = 0) = k >= 5 || T < an_d[k] ? [k, max(0, min(1, T / an_d[k]))] : an_phase(T - an_d[k], k + 1);
function an_pin(t) = let(p = an_phase(t * an_tot), k = p[0], f = 0.5 - 0.5*cos(180*p[1]))
  k == 0 ? [u_a, v_n] :
  k == 1 ? let(u = u_a + (u_stop - u_a)*f) [u, path_v(cam_paths[2], u)] :
  k == 2 ? let(u = u_stop - (u_stop - an_umin)*f) [u, v_exit(u)] :
  k == 3 ? [an_umin, v_free(an_umin)] :
  k == 4 ? let(u = an_umin + (u_stop - an_umin)*f) [u, v_entry(u)] :
           let(u = u_stop - (u_stop - u_a)*f) [u, path_v(cam_paths[1], u)];
// static assembly: the slider, with the pin on the exit path (the drawer was released and pulled out)
function slider_pin() = let(u = u_stop - (Dd - 15) * max(0, min(100, assembly_open_pct)) / 100) [u, v_exit(u)];

// ---- energy map (part = energy_map). Each band is modelled as a linear spring: tension =
// strength * (stretched length / relaxed length - 1), so its stored energy is
// strength * (L - C)^2 / (2 C) for loop path L and relaxed circumference C (0 when slack).
// The drawer can only run by itself where the total goes downhill.
function band_e(n, L, C) = L > C ? n * pow(L - C, 2) / (2*C) : 0;
// latch band: the two strands run spreader -> arm tip -> back post; the tip pushes a strand out
// where it reaches past the strand's straight line. s = pin's sideways offset from rest.
el_C = cband_loop / 1.5;                       // the band the console recommends (stretched 1.5x on straight strands)
function el_len(s) = let(ph = asin(max(-1, min(1, s / arm_r))),
    tx = x_pv + arm_r*cos(ph), ty = arm_r*sin(ph))
  cband_loop - 2*cband_len + sum([for (k = [-1, 1]) let(P = [tx, ty + k*arm_w/2],
    S = [x_sp, k*cband_spread/2], B = [x_bpost, k*cpost_d/2])
    k*P[1] > band_y(tx) ? norm(P - S) + norm(B - P) : cband_len]);
function sum(a, i = 0) = i >= len(a) ? 0 : a[i] + sum(a, i + 1);
function e_latch(v) = band_e(latch_band_n, el_len(v - cam_rest_v), el_C);
// ejector, with the drawer x mm out (band strength: kicker_band_n for the kicker, else ejector_band_n)
ej_n = ej_kick ? kicker_band_n : ejector_band_n;
function e_eject(x) = ej_kick
  ? band_e(ej_n, k_len(Dd - x, k_a), 2*k_band)
  : band_e(ej_n, 2*(2*norm([Dd - x - x_post + post_d/2, y_post - y_bl]) + 2*y_bl) + PI*post_d,
           2*back_band_len);
function e_tot(x, v) = e_latch(v) + e_eject(x);
// pin's sideways position on the two runs that must go by themselves, x mm out
function v_out(x)   = v_exit(u_stop - x);                                       // released
function v_notch(x) = let(u = u_stop - x) u >= u_D ? v_tr : path_v(cam_paths[1], u);   // let go after push 1
// walk a run in em_dx steps: [x, E] samples
em_dx = 0.1;
function em_run(f, x1) = [for (x = [0:em_dx:x1]) [x, e_tot(x, f(x))]];
// uphill stretches of a run: [[x from, x to, rise mJ]]
function em_up(R, i = 0, st = -1, acc = []) =
  i >= len(R) - 1 ? (st >= 0 ? concat(acc, [[R[st][0], R[i][0], R[i][1] - R[st][1]]]) : acc) :
  let(up = R[i+1][1] > R[i][1] + 1e-6)
  up ? em_up(R, i + 1, st < 0 ? i : st, acc)
     : em_up(R, i + 1, -1, st >= 0 ? concat(acc, [[R[st][0], R[i][0], R[i][1] - R[st][1]]]) : acc);
// least net push along a run (N = mJ/mm): the drop in energy per mm of travel
function em_minpush(R, x1 = 1e9) = let(F = [for (i = [0:len(R)-2]) if (R[i][0] < x1) [(R[i][1] - R[i+1][1]) / em_dx, R[i][0]]])
  F[search(min([for (f = F) f[0]]), [for (f = F) f[0]])[0]];
module energy_map() {
  x_lat = u_stop - u_a;
  x_end = max(ej_rest, u_stop + 3);
  out = em_run(function(x) v_out(x), x_end);
  ret = em_run(function(x) v_notch(x), x_lat);
  echo(str("ENERGY MAP: latch band ", latch_band_n, " N, ejector band ", ej_n,
           " N (strength = pull to stretch to 2x). Energies in mJ (N*mm); push in N"));
  pts = [
    ["latched (pin in the notch)",                 x_lat,           v_n],
    ["pushed to the stop, released",               0,               v_le],
    ["exit curve starts",                          u_stop - u_4s,   v_out(u_stop - u_4s)],
    ["arm swung furthest (left channel)",          u_stop - u_4e,   v_l],
    ["left channel ends, band starts to help",     ej_free,         v_l],
    ["pin leaves the groove (reset for the next close)", u_stop,  0],
    [ej_kick ? "kicker lets go" : "back band relaxed", ej_rest, v_out(ej_rest)]];
  for (p = pts) echo(str("  ", r1(p[1]), " mm out, pin v ", r1(p[2]), ": latch ", r1(e_latch(p[2])),
                         " + ejector ", r1(e_eject(p[1])), " = ", r1(e_tot(p[1], p[2])), "  ", p[0]));
  closing = e_tot(0, v_tr) - e_tot(x_end, cam_rest_v);
  echo(str("  closing from ", r1(x_end), " mm out to the stop stores ", r1(closing), " mJ (your push)"));
  for (run = [["released -> open", out, u_stop], ["let go after push 1 -> notch", ret, x_lat]]) {
    up = em_up(run[1]);
    mp = em_minpush(run[1], run[2]);
    if (len(up) == 0)
      echo(str("  ", run[0], ": downhill all the way; least net push ", r1(mp[0]), " N at ", r1(mp[1]), " mm out", run[2] == u_stop ? str(" while the pin is in the groove; ", r1(e_tot(u_stop - 0.5, v_out(u_stop - 0.5)) - e_tot(u_stop + 0.5, v_out(u_stop + 0.5))), " N as it leaves") : ""));
    else for (u = up)
      echo(str("  WARNING ", run[0], ": uphill from ", r1(u[0]), " to ", r1(u[1]), " mm out (+", round(u[2]*100)/100,
               " mJ), the drawer stops here unless momentum carries it"));
  }
  // the kicker lets go of the drawer, so friction is all that stops it (rough: PLA on PLA, 0.3)
  if (ej_kick) {
    c = k_coast(ej_n, d_mass);
    echo(str("  kicker with a ", ej_n, " N band: gives ", r1(ej_n*k_e1), " mJ; an empty drawer (~",
             round(d_mass), " g) ", c > 0 ? str("coasts ~", round(c), " mm past the ", k_s, " mm push (~", round(k_s + c),
             " mm open", k_s + c > Dd - 15 ? ", WARNING: that throws it out – use a weaker band" : "", ")")
             : "stops before the push ends", "; it still resets with up to ~", round(max(0, k_maxg(ej_n) - d_mass)),
             " g inside (suggested band for this drawer: ~", r1(k_n_rec), " N)"));
  }
}

// The assembled drawer with the pin at cam position pin = [u, v]: the drawer is out u_stop - u, and
// the arm swings so the pin sits at v. hmode: "solid", "ghost" or "groove" (housing left out except
// for an outline of the groove and the band posts); dmode: "solid" or "ghost". Ghosts use OpenSCAD's
// % modifier (drawn last, see-through, F5 only).
module scene(pin, hmode, dmode) {
  open = u_stop - pin[0];
  s = pin[1] - cam_rest_v;                   // pin's sideways offset from rest
  phi = asin(max(-1, min(1, s / arm_r)));    // arm swing (deg, + toward +y)
  if (hmode == "solid") color("SteelBlue", 0.85) housing();
  else if (hmode == "ghost") %housing();
  else color("SteelBlue") {
    // groove walls as a 0.8 mm outline, at the plate's underside where the pin runs
    translate([0, 0, -plate_t]) linear_extrude(1) difference() { offset(r = 0.8) groove_2d(); groove_2d(); }
    if (ej_kick) kick_posts(); else for (m = [0,1]) mirror([0, m, 0]) band_post(x_post);
  }
  translate([-open, 0, 0]) {
    if (dmode == "ghost") %drawer(); else color("Orange") drawer();
    color("Crimson") translate([x_pv, yb, z_arm]) rotate([0, 0, phi]) latch_arm();
    // latch centring band: two strands from the spreader past the arm tip to the back post; the
    // tip pushes the strand on the side it swings to outward
    tip = [x_pv + arm_r*cos(phi), yb + arm_r*sin(phi)];
    color("Black") for (k = [-1,1]) {
      pts = [[x_sp, yb + k*(cband_spread/2 + 0.5)],
             [tip[0], yb + k*(arm_w/2 + 0.5) + (k*s > 0 ? tip[1] - yb : 0)],
             [x_bpost, yb + k*(cpost_d/2 + 0.5)]];
      for (i = [0:1]) hull() for (p = [pts[i], pts[i+1]]) translate([p[0], p[1], z_tun]) sphere(d = 1, $fn = 8);
    }
  }
  // ejector rubber band: the back band from the posts (inner side) through the loops on the
  // drawer's back, so it follows the drawer (stretched behind the posts when closed, the other way
  // when pulled out past them); the kicker's two strands straight across between its posts, or,
  // once the drawer's back reaches them, from the posts round the back of the latch pocket
  if (ej_kick) color("Black") let(X = Dd - open + 0.6)
    for (xj = [x_kp - kp_d/2 - 0.5, x_kp + kp_d/2 + 0.5]) let(
      P = X > xj ? [[xj, yk - k_a], [X, yk - k_n], [X, yk + k_n], [xj, yk + k_a]] : [[xj, yk - k_a], [xj, yk + k_a]])
      for (i = [0:len(P)-2]) hull() for (p = [P[i], P[i+1]]) translate([p[0], p[1], z_kb]) sphere(d = 1.2, $fn = 8);
  else color("Black") for (m=[0,1]) mirror([0,m,0])
    let(xb = Dd - open + 1.5, zb = max(z_band, z_bot + bl_r + 1.6))   // zb: as in back_loop()
      for (seg = [[[x_post, y_post - post_d/2 - 0.5, z_band], [xb, y_bl, zb]], [[xb, y_bl, zb], [xb, 0, zb]]])
        hull() for (p = seg) translate(p) sphere(d = 1.2, $fn = 8);
}

if (part == "print_layout" || (part == "assembly" && !$preview)) print_layout();
else if (part == "assembly") scene(slider_pin(), "solid", "solid");
else if (part == "animation") scene(an_pin($t), "groove", animation_drawer);
else if (part == "energy_map") { energy_map(); cube(1); }
else if (part == "housing") rotate([180,0,0]) housing();   // desk face down on the bed
else if (part == "drawer")  translate([0,0,-z_bot]) drawer();
else if (part == "arm")     latch_arm();                    // flat on the bed, pin up
else if (part == "cam_2d")  cam_2d();
else if (part == "cam_paths") {
  // machine-readable dump for the latch simulator
  echo(str("CAM r_eff=", r_eff, " pin_r=", pin_d/2, " u_stop=", u_stop, " U=", U, " u_a=", u_a));
  echo(str("ARM r=", arm_r, " rest=", cam_rest_v));
  echo(str("BEND tightest pin-path radius inside a path: ", cam_min_r, " mm (r_eff ", r_eff, "; path ends excluded: those are the cusps)"));
  for (p = cam_paths) echo(str("PATH ", p));
  cube(1);
}
