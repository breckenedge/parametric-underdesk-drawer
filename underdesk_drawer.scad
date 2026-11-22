// =====================================================================
//  Parametric Under-Desk Drawer  —  push-to-open, support-free
//  OpenSCAD (nightly, Manifold backend recommended)
//
//  Parts:
//    housing  : screws to the underside of the desk. Print UPSIDE DOWN
//               (desk face on the bed) – exported that way.
//    drawer   : the drawer body; print upright, floor on the bed. Its front can have
//               screw holes for a wood face.
//    cassette : the latch and kicker parts on one tray, held in a notch in the
//               drawer's back; print flat, tray on the bed.
//    arm      : latch arm; print flat, pin up.
//
//  Slide   : 45° dovetail lips on the drawer ride on 45° ledges in the
//            housing. Self-centering, no bearings, no supports.
//  Latch   : push-push heart-cam groove cut into the housing plate. A rigid
//            arm carrying the pin swings sideways on a post in a pocket on the
//            cassette; a rubber band stretched past both sides of it
//            (spreader in front, post behind) pulls it back to centre. No printed part flexes.
//  Catch   : a jog in the groove near the housing's front, so an open drawer stops before
//            it comes right out; a firm pull gets it past.
//  Ejector : a kicker, a short band on two posts hanging from the housing either
//            side of the cassette, which the cassette's back pushes into on close.
//
//  Hardware: countersunk wood screws (default #8 / 4 mm; 4 on small drawers, more
//            on long ones – see screw_spacing), two rubber bands, 2 M3 bolts and nuts
//            (none with cassette_mount = mortise).
//
//  Parts not in the list below, for the command line (-D part=...): energy_map prints the bands'
//  stored energy through one cycle, cam_paths dumps the groove for the simulators in tools/.
// =====================================================================

/* [View] */
// assembly: F5 shows it assembled, F6 lays the parts out for printing. animation: needs the Animate panel (FPS 15, Steps 200)
part = "assembly"; // [assembly, animation, print_layout, housing, drawer, cassette, arm]
// Assembly: how far the drawer is pulled out (100% = all but 15 mm)
assembly_open_pct = 0; // [0:1:100]
// Animation: the drawer solid, or see-through so the bands behind it show
animation_drawer = "solid"; // [solid, ghost]

/* [Drawer] */
// Inside width
inner_w = 150;  // [84:0.1:500]
// Inside depth (at least 100 with the pull-out catch)
inner_d = 200;  // [62:0.1:500]
// Inside height
inner_h = 30;  // [17:0.1:300]
// Side and back wall thickness
wall = 2; // [1:0.1:6]
// Floor thickness
floor_t = 1.6; // [0.8:0.1:5]
// Front panel thickness (on top of the front wall). 0 = no panel: the wood face goes straight on the box and is the closing stop
panel_t = 4; // [0:0.1:15]

/* [Wood face] */
// Screw holes through the drawer's front, to screw a wood face on from inside
wood_face = false;
// Thickness of the wood (for the screw length, the weight and the view)
wood_face_t = 12; // [6:0.1:30]
// Countersunk wood screw size
wood_face_screw = 3.5; // [3.5:#6 / 3.5 mm, 4:#8 / 4 mm, 4.5:#9 / 4.5 mm, 5:#10 / 5 mm]

/* [Housing] */
// Thickness of the plate against the desk
plate_t = 5; // [4.4:0.1:12]
// Side wall thickness
housing_wall = 3; // [1.2:0.1:8]
// Cut windows in the plate to save plastic
plate_windows = true;
// Countersunk wood screw size, into the desk
screw = 4; // [3.5:#6 / 3.5 mm, 4:#8 / 4 mm, 4.5:#9 / 4.5 mm, 5:#10 / 5 mm]
// Most space between desk screws along each side (never fewer than 2 a side)
screw_spacing = 100; // [40:0.1:200]

/* [Latch] */
// Stop an open drawer before it comes right out (a firm pull gets it past)
catch = true;
// How the latch cassette is held in the drawer's back
cassette_mount = "captive_nut"; // [captive_nut:bolts into captive nuts, normal:bolts and loose nuts, mortise:dovetail - no hardware]
// Cassette bolt size (not for the dovetail)
cassette_bolt = 3; // [2.5:M2.5, 3:M3, 4:M4, 5:M5]

/* [Rubber bands] */
// Strength of the kicker band: the pull (N) that stretches it to twice its length. 1/16 inch wide is about 2, 1/8 inch about 4
kicker_band_n = 4; // [0.2:0.1:20]
// Strength of the latch band (only for the estimates in the console)
latch_band_n = 2; // [0.5:0.1:20]

/* [Fit] */
// Gap across the 45° sliding faces
slide_clr = 0.35; // [0:0.05:1.5]
// Gap between the drawer's lips and the housing's sides
side_clr = 0.6; // [0:0.05:2]
// Gap around the latch pin in its groove
pin_clr = 0.35; // [0:0.05:1]
// Gap around the latch arm's pivot post
arm_clr = 0.2; // [0:0.05:1]
// Gap around the cassette's dovetail
mortise_clr = 0.15; // [0:0.05:0.6]

/* [Hidden] */
// ------------------------------------------------------------- fixed dimensions
// Slide
lip = 5;              // 45° lip on each side of the drawer
lip_edge = 1.5;       // vertical flat on the lip tip
ledge_min = 3;        // material under the ledge's 45° face at its thinnest
top_gap = 1;          // drawer rim to housing plate
panel_top_gap = 1;    // front panel's top edge to the desk
// Vertical corners, rounded because a sharp corner is where a print curls off the bed first. Not the
// housing's front ones: the front panel stops against that face
corner_h = 5;         // housing, back
corner_d = 3;         // drawer, back and front panel, or the box's front without a panel (less if the wall or the panel is too thin for it)
// Latch. After changing any of these, run the simulators in tools/
latch_y = 0;          // sideways shift of the latch and its cassette (+ = left, seen from the front)
pin_d = 3;
pin_h = 3.2;          // pin above the drawer rim
groove_depth = 3.4;
cam_wall_min = 1.6;   // printed wall between groove branches
stop_back = 1.2;      // how far short of the groove end the panel stops the drawer
// Latch arm: a rigid part that carries the pin. It swings sideways on a post at its front end, so it
// can't jam or tip like a slider. The groove is corrected for the arc the pin travels.
arm_r = 26;           // pivot to pin
arm_w = 8;            // width at the tip
arm_h = 7;
arm_post_d = 5;       // pivot post
// Latch band: one band stretched lengthwise around a spreader in front of the arm's hub and a post
// behind its tip. The arm sits between the two strands; when it swings, its tip pushes one strand out
// like a bowstring. Nothing to thread, and a doubled band works too.
cband_back = 8;       // arm tip end to the back post
cband_spread = 13;    // spreader width (strand spacing at the front)
cpost_d = 4;
// Pull-out catch: a jog in the groove's straight run near the housing's front. Pulling takes the pin up
// a steep face, against the latch band; pushing back in takes it up a 45° ramp.
catch_h = 7;          // how far the jog swings the arm
catch_angle = 60;     // steepness on the way out, degrees off the direction of travel. Friction counts for
                      // a lot: past about 70 the drawer may not come out at all
// Cassette
mortise_angle = 20;   // the dovetail's side angle
// Kicker
band_stroke = 32;     // how far it pushes (raised to what the latch needs if lower)
post_d = 6;
// Plate windows
window_rib = 8;
window_target = 40;

$fn = $preview ? 32 : 64;
eps = 0.01;
s2 = sqrt(2);
// Countersunk wood screws: [nominal shank d, max head d]. Head sizes are the
// metric (DIN 7505 / ISO 7046) maxima, which also cover the US flat-head gauges.
screw_table = [[3.5, 7.0], [4.0, 8.0], [4.5, 9.0], [5.0, 10.0]];
// (tolerates "4", a string, from -D or presets saved with an earlier version)
function screw_row(s) = [for (r = screw_table) if (r[0] == s || str(r[0]) == s) r][0];
for (s = [screw, wood_face_screw]) assert(!is_undef(screw_row(s)), str("Unknown screw size ", s, " – pick one from the list"));
screw_d      = screw_row(screw)[0] + 0.4;   // clearance hole
screw_head_d = screw_row(screw)[1] + 0.6;   // countersink diameter at flush
// Extra recess below flush so heads never touch the drawer
screw_recess = 0.4;

// Smallest sizes that work with M3 captive nuts (bigger bolts need a little more width, mortise a little
// less). Anything lower (e.g. a value the Customizer kept from an older version of this file) is raised to
// the minimum, with a warning, instead of failing.
// Width: the kicker posts and the cassette's ears either side of the latch. Height: room for the cassette's
// notch in the back wall. Depth: the latch arm and its band, spreader to back post; with the pull-out
// catch a drawer stops about 35 mm short of its depth, so it is kept deep enough to open about two thirds
// of the way (and past the kicker's push).
min_w = 84;  min_d = catch ? 100 : 62;  min_h = 17;
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
// Place the arm so the groove's lateral extent (v_l..v_rc) is centred,
// then shift by latch_y. +y is the drawer's left, seen from the front.
yb_c = -((v_l + v_rc)/2 - cam_rest_v);          // arm centre line for a centred groove
// Screws go in straight up from below with the drawer out, so the whole countersink
// (and the head/driver passing through it) must sit inside the ledges' inner edge.
screw_cs_r = screw_head_d/2 + screw_recess;
screw_y = y_li - screw_cs_r - 1;
yb = latch_y + yb_c;                            // arm centre line (pin at rest)
x_bpost = Dd - wall - 2 - cpost_d/2;            // 2 mm behind it for the band to wrap
x_tip = x_bpost - cband_back;                   // arm tip end (rounded, radius arm_w/2)
x_pin = x_tip - arm_w/2;                        // pin sits at the centre of the rounded tip
x_pv  = x_pin - arm_r;                          // pivot post
hub_d = arm_post_d + 2*arm_clr + 2*2.4;
x_sp  = x_pv - hub_d/2 - 1 - cpost_d/2 - spool_fl;   // spreader, just clear of the hub
phi_l = asin(min(1, throw_l / arm_r));          // arm swing each way (deg)
phi_r = asin(min(1, throw_r / arm_r));
x_cam0 = x_pin - u_stop;          // housing x of cam origin u=0
// The pin swings on an arc: at lateral offset s from rest it sits arm_r - sqrt(arm_r²-s²)
// further forward, so the groove is drawn through that correction.
function cam2h(p) = let(s = p[1] - cam_rest_v)
  [x_cam0 + p[0] - arm_r + sqrt(arm_r*arm_r - s*s), yb + s];
// The straight run from the cam's mouth (0, 0) to the plate's front, with the pull-out catch in it: from
// the front, at the arm's rest position, a 45° ramp up to a peak catch_h off rest, then down at
// catch_angle to the mouth's straight, which settles the pin before it reaches the cam. The band
// holds the pin against the inner wall of both slopes. The peak's corner is drawn higher (catch_o)
// so that its arc, wider than the pin's, tops out at catch_h. Runs inward.
catch_ramp = 45;
catch_r = 2.2;
catch_x = 2;                                    // the ramp starts this far inside the plate's front
catch_o = catch_r * (cos((catch_angle - catch_ramp)/2) / cos((catch_angle + catch_ramp)/2) - 1);
catch_u0 = catch_x - x_cam0;
catch_u1 = catch_u0 + (catch_h + catch_o) / tan(catch_ramp);
catch_u2 = catch_u1 + (cam_rest_v + catch_h + catch_o) / tan(catch_angle);   // foot of the steep face
mouth_spec = !catch ? [[-x_cam0 - 5, 0], [0, 0]]
  : [[-x_cam0 - 5, cam_rest_v], [catch_u0, cam_rest_v, 2], [catch_u1, cam_rest_v + catch_h + catch_o, catch_r],
     [catch_u2, 0, 2], [0, 0]];
assert(catch_u2 < 0 && fillet_fits(mouth_spec), "no room for the pull-out catch – raise inner_d");
mouth_path = fillet_path(mouth_spec);
catch_uf = catch ? catch_u2 + 2*tan(catch_angle/2) : -x_cam0;   // pulled out, the pin meets the catch (or the front) here
groove_y0 = yb - cam_rest_v + v_l  - r_eff;   // groove lateral extent in housing coords
groove_y1 = yb - cam_rest_v + v_rc + r_eff;

// pocket: guard walls around the arm's swing and the band (outer faces)
pocket_y0 = yb - throw_l - arm_w/2 - 2.5 - 1.2;
pocket_y1 = yb + throw_r + arm_w/2 + 2.5 + 1.2;
pocket_x0 = x_sp - cpost_d/2 - spool_fl - 1.5 - 1.2;

// arm heights (world z, use orientation)
z_arm = z_rim - arm_h;                          // arm bottom; its top is flush with the rim
z_tun = z_arm + arm_h/2;                        // band height

// the cassette's floor: flat top at z_mf, 2 mm under the arm, so its posts stay short
z_mf = z_arm - 2;
// band strands at rest: straight from the spreader's sides to the back post's sides
function band_y(x) = cband_spread/2 + (cpost_d/2 - cband_spread/2) * (x - x_sp) / (x_bpost - x_sp);
cband_len = norm([x_bpost - x_sp, cband_spread/2 - cpost_d/2]);
cband_loop = 2*cband_len + PI*cpost_d + (cband_spread - cpost_d);

// The ejector also has to carry the pin out of the latch groove. The drawer only runs by itself
// while the bands' total stored energy keeps falling (part = energy_map prints it): if the kicker
// lets go before the pin has left the groove (u_stop mm out), the drawer stops with the pin still
// on the exit path, not reset for the next close. So the stroke is at least ej_need, 5 mm past the
// groove mouth, so the band is still pushing there.
ej_free = u_stop - abs(v_l);       // the latch band resists until here (the left channel's end), then helps
ej_need = ceil(u_stop) + 5;

ct_t = 2;                      // cassette tray thickness
// cassette mount. Bolts: [M size, clearance hole, nut across flats, nut thickness]
cm_nut = cassette_mount == "captive_nut";
cm_mort = cassette_mount == "mortise";
cb_row = [for (r = [[2.5, 2.9, 5, 2], [3, 3.4, 5.5, 2.4], [4, 4.5, 7, 3.2], [5, 5.5, 8, 4]]) if (r[0] == cassette_bolt) r];
cb = len(cb_row) > 0 ? cb_row[0] : [3, 3.4, 5.5, 2.4];
cb_hole = cb[1];
nut_af = cb[2] + 0.3;  nut_t = cb[3] + 0.3;     // hex slot, with clearance
nut_ac = nut_af / cos(30);                      // across its corners (up and down the slot)
// cassette ears, against the back's inner face: they carry the bolts (the nut slot in captive_nut),
// or for mortise only stop the cassette moving back
ear_t = cm_nut ? nut_t + 1.6 : 3;
ear_w = cm_mort ? 4 : cm_nut ? nut_af + 2.4 : cb_hole + 4.6;

// kicker: a short band on two posts hanging from the housing, one each side of the latch pocket,
// always a little stretched (k_pre), so it is never slack and has nothing to fall off. It is never
// attached to the drawer: over the last k_s mm of closing the back of the latch cassette (the
// "nose") pushes the middle of the band back into a V, and released, the band pushes it out again
// and lets go. Each post runs in a notch cut into the top of the cassette's back, inside a small
// walled bay so nothing in the drawer gets in its way.
// After the band lets go friction stops the drawer (and the pull-out catch, weakly). So the band has to be weak
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
k_rp = kp_r + kp_clr;                          // post's swept radius, with its clearance
k_xf = x_kp - k_rp - k_bw;                     // the bays' front walls
k_amin = k_n + k_rp + 0.3;                      // post track clear of the pocket wall
// bay and cassette ear inside the side wall
k_ylim = min(Wd/2 - wall - k_bw - kp_r - kp_clr - ear_w - 0.5,
             screw_y - screw_cs_r - 1 - kp_r);   // post clear of the countersinks

// Mostly friction stops the drawer once the kicker lets go, so the band is sized for the drawer's weight.
// Rough weight: PLA ~1.24 g/cm³, walls printed solid; a wood face ~0.6 g/cm³, taken as big as the front
// panel. The drawer hangs on 45° ledges, which presses them with sqrt(2) x its weight; PLA on PLA ~0.3.
panel_w = 2*y_ho;                               // front panel: as wide as the housing
panel_h = -panel_top_gap - z_bot;
d_mass = 1.24e-3 * (Wd*Dd*floor_t + 2*(Wd + Dd)*wall*in_h + panel_w*panel_h*panel_t
                    + 2*Dd*(lip*lip/2 + lip*lip_edge) + (Dd - pocket_x0)*(2*k_n + 60)*4)   // g (cassette too)
         + (wood_face ? 0.6e-3 * panel_w*panel_h*wood_face_t : 0);
k_mu = 0.3;
function fric(g) = k_mu * sqrt(2) * g * 9.81e-3;    // N, for a drawer + contents of g grams
// what the latch band takes back on the way out: the hill from released to the arm's furthest swing
k_hill = max(0, e_latch(v_l) - e_latch(v_le));
// the pull-out catch: the sideways push of the band at the peak, through a face at angle a with friction
// (k_mu), is the pull it takes; and the work a moving drawer loses climbing it
function catch_f(a) = e_latch(cam_rest_v + catch_h) < 1e-9 ? 0
  : (e_latch(cam_rest_v + catch_h) - e_latch(cam_rest_v + catch_h - 0.1))/0.1 * tan(a + atan(k_mu));
catch_w = catch ? (e_latch(cam_rest_v + catch_h) - e_latch(cam_rest_v)) * tan(catch_angle + atan(k_mu)) / tan(catch_angle) : 0;
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
k_fit = len(k_cands) > 0 && z_knb > z_bot + floor_t + 2 && k_xf > pocket_x0;
k_best = k_fit ? min([for (c = k_cands) c[2]]) : 0;
// the cassette is as wide as the posts are apart, so keep it as narrow as possible: the shortest
// length a band you can buy (k_nmin, a 1/16" band is about 2 N) suits; the console then says what
// strength to use. If none does (a very light drawer), the length nearest kicker_band_n.
k_nmin = 2;
k_short = [for (c = k_cands) if (k_nrec_of(c[0], c[1]) >= k_nmin) c];
k_pick = !k_fit ? [38.1, k_amin, 0]
       : len(k_short) > 0 ? k_short[0]
       : [for (c = k_cands) if (c[2] <= k_best + 1e-9) c][0];
k_band = k_pick[0];                             // flat length
k_a = k_pick[1];                                // post offset from yk
k_stretch = k_len(Dd, k_a) / (2*k_band);
k_e1 = k_e1_of(k_band, k_a);
k_n_rec = k_nrec_of(k_band, k_a);
// the cassette sits in a notch in the drawer's back wall, which leaves at least 5 mm of wall under it
c_deep = (z_mf - ct_t - 1) - (z_bot + floor_t) >= 5;
c_need_h = ceil(in_h + 5 - ((z_mf - ct_t - 1) - (z_bot + floor_t)));
// the cassette: from the pocket's front to the back, as wide as the kicker bays
yc0 = yk - (k_a + k_rp + k_bw);
yc1 = yk + (k_a + k_rp + k_bw);
z_cb = z_mf - ct_t;                             // cassette bottom (tray underside)
ej_rest = k_s;                                  // where the kicker stops pushing
function k_coast(n, g) = (n*k_e1 - k_hill - fric(g)*k_s) / fric(g);   // mm past the stroke end
// N*mm left over at the pull-out catch (or 15 mm short of falling out) once the kicker has thrown the empty drawer
catch_out = catch ? u_stop - catch_uf : Dd - 15;   // how far out that is
function k_thrown(n) = n*k_e1 - k_hill - fric(d_mass)*catch_out - catch_w;
function k_maxg(n) = (n*k_e1 - k_hill) / fric(1) / u_stop;            // drawer + contents (g) that still resets

screw_n_side = max(2, ceil((Dh - 24) / screw_spacing) + 1);   // screws per side, 12 mm in from each end
screw_xs = [for (i = [0:screw_n_side-1]) 12 + i * (Dh - 24) / (screw_n_side - 1)];

// wood face: screws through the front panel and the drawer's front wall from inside, heads countersunk
// into the wall's inner face. A column 12 mm in from each side wall and more between on wide drawers, two
// rows on tall ones.
wf_d = screw_row(wood_face_screw)[0] + 0.4;
wf_r = (screw_row(wood_face_screw)[1] + 0.6)/2;  // countersink radius
wf_n = max(2, ceil((in_w - 24)/200) + 1);
wf_ys = [for (i = [0:wf_n-1]) -in_w/2 + 12 + i*(in_w - 24)/(wf_n - 1)];
wf_zs = [for (f = in_h >= 50 ? [0.25, 0.75] : [0.5]) z_bot + floor_t + f*in_h];

// ------------------------------------------------------------- checks
assert(k_fit, "the kicker doesn't fit beside the latch pocket – increase inner_w (or inner_d / inner_h)");
echo(str("Drawer body ", Wd, " x ", Dd, " x ", Hd, " mm; housing ", 2*y_ho, " x ", Dh,
         " x ", -z_hbot, " mm (+ kicker posts)"));
echo(str("Latched drawer sits ", u_stop - u_a, " mm proud; push-release travel the same"));
echo(str("Latch cassette ", round(yc1 - yc0 + 2*ear_w), " mm wide (with its ears), ", round(Dd - pocket_x0), " deep: room beside it at the back: ",
         max(0, round(Wd/2 - wall - yc1 - ear_w)), " mm on the left, ", max(0, round(yc0 - ear_w + Wd/2 - wall)), " mm on the right"));
echo(str("Desk screws: ",2*screw_n_side, " (", screw_n_side, " per side, ",
         round((Dh - 24)/(screw_n_side - 1)), " mm apart)"));
function r1(x) = round(x*10)/10;
echo(str("Ejector: kicker – 1 band of ", k_band/25.4, "\" (", round(k_band), " mm) flat length around the two posts",
         " (", round(2*k_a), " mm apart) behind the latch pocket. It stays on the posts, stretched ", k_pre, "x open and ",
         r1(k_stretch), "x closed, and pushes the drawer ", k_s, " mm, then lets go; friction", catch ? " (and the pull-out catch)" : "", " stops it after that"));
let(c = k_coast(kicker_band_n, d_mass))
echo(str("Kicker band: ", kicker_band_n, " N (kicker_band_n; 1/16\" wide is about 2 N, 1/8\" about 4 N), drawer of roughly ",
         round(d_mass), " g; ", r1(k_n_rec), " N would suit this length best. Rough guide",
         " (friction varies): empty, it coasts ~", round(max(0, c)), " mm past the ", k_s, " mm push (~", round(k_s + max(0, c)),
         " mm open of ", Dd, "), and it still opens far enough to reset the latch with up to ~",
         round(max(0, k_maxg(kicker_band_n) - d_mass)), " g inside. A heavier load stops it short (a pull resets it);",
         " a stronger band throws it further"));
if (k_thrown(kicker_band_n) > 0)
  echo(str("WARNING: a ", kicker_band_n, " N kicker band can throw this empty drawer out – use a weaker one (about ",
           r1(k_n_rec), " N)"));
if (abs(ln(k_n_rec / kicker_band_n)) > ln(1.25))
  echo(str("WARNING: the kicker band is the shortest that keeps the cassette narrow; it wants about ", r1(k_n_rec),
           " N – use a band about that strong and set kicker_band_n = ", r1(k_n_rec), " (now ", kicker_band_n, ")"));
echo(catch ? str("Pull-out catch: the open drawer stops ", round(catch_out), " mm out of ", Dd, "; pulling it past takes roughly ",
                 r1(catch_f(catch_angle)), " N and pushing it back in ", r1(catch_f(catch_ramp)), " N (with a ", latch_band_n,
                 " N latch band, latch_band_n; friction varies)")
           : "Pull-out catch: none");
c_fix_txt = cm_mort ? "slide it down into the notch; the ears stop it on the inside"
          : str("drop it into the notch; 2 M", cassette_bolt, " bolts through the back and its ear slots",
                cm_nut ? ", into nuts pushed into the ears' hex slots" : ", with nuts");
echo(str("Latch cassette mount: ", cassette_mount, " – ", c_fix_txt));
if (wood_face) echo(str("Wood face: ", len(wf_ys)*len(wf_zs), " countersunk wood screws from inside the drawer, up to ",
  wall + panel_t + wood_face_t - 2, " mm long (", wall + panel_t, " mm of printed front + the wood, less 2). A face of ",
  r1(panel_w), " x ", r1(panel_h), " mm ", panel_t > 0 ? "just covers the printed front" :
  "just covers the housing; it is the closing stop, so keep it wider than the opening and tall enough to reach the housing's plate"));
else if (panel_t == 0) echo("WARNING: with no front panel and no wood face the drawer has no closing stop, so the latch pin takes every push");
echo(str("Latch centring band: loop path ", round(cband_loop), " mm -> use a band of ~",
         round(cband_loop/1.5), " mm circumference (flat length ~", round(cband_loop/3),
         " mm), or a smaller one doubled"));
assert(z_arm - 2 > z_bot + floor_t, "Drawer too shallow for the latch arm – increase inner_h");
assert(throw_r < arm_r - 8, "arm_r too short for the cam's sideways travel");
assert(x_bpost - cpost_d/2 - spool_fl - x_tip >= 1.5, "cband_back too short – band post hits the arm tip");
assert(band_y(x_pv) >= hub_d/2 + 0.4, "latch band strands rub the arm's hub – increase cband_spread");
assert(band_y(x_pin) <= arm_w/2 - 0.4, "latch band strands don't press on the arm tip – reduce cband_spread or widen arm_w");
assert(pocket_x0 > wall + 5, "inner_d too small for the latch pocket");
assert(x_cam0 > 8, "inner_d too small for the latch groove");
assert(x_cam0 + U + r_eff < Dh, "cam does not fit");
assert(pocket_y1 < Wd/2 - wall - 5 && pocket_y0 > -Wd/2 + wall + 5,
       "latch pocket hits a side wall – inner_w too small or latch_y too far off-centre");
assert(screw_y + screw_cs_r < y_li, "screw countersink overlaps the slide ledge");
assert(groove_y1 + 1 + screw_head_d/2 < screw_y && groove_y0 - 1 - screw_head_d/2 > -screw_y,
       "latch groove runs into a screw row – move latch_y toward the centre");
assert(!k_fit || (yk + k_a - kp_r > groove_y1 + 1 && yk - k_a + kp_r < groove_y0 - 1),
       "kicker posts run into the latch groove");
assert(c_deep, str("drawer too shallow for the latch cassette – inner_h needs about ", c_need_h));
assert(cm_nut || cm_mort || cassette_mount == "normal", "cassette_mount must be captive_nut, normal or mortise");
assert(cm_mort || len(cb_row) > 0, "cassette_bolt must be 2.5, 3, 4 or 5");

// ============================================================= modules
module capsule2d(a, b, r) { hull() { translate(a) circle(r); translate(b) circle(r); } }

// ---- housing (use orientation: z = 0 is the desk underside)
module rail_profile() {   // right side, (y, z)
  polygon([
    [y_li, z_hbot], [y_ho, z_hbot], [y_ho, -plate_t/2], [y_hi, -plate_t/2],
    [y_hi, ledge_top(y_hi)], [y_li, ledge_top(y_li)]
  ]);
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
    for (p = concat(cam_paths, [mouth_path])) for (i = [0:len(p)-2]) let(n = pieces(p[i], p[i+1])) for (k = [0:n-1])
      capsule2d(cam2h(p[i] + (p[i+1]-p[i])*k/n), cam2h(p[i] + (p[i+1]-p[i])*(k+1)/n), r_eff);
    // lead-in funnel at the plate's front, done before the catch's ramp so it doesn't cut into it
    hull() let(y = yb - cam_rest_v + mouth_path[0][1]) {
      translate([-2, y]) circle(r_eff + 2.5);
      translate([catch ? catch_x : 8, y]) circle(r_eff);
    }
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
  // a cell that would come within 3 mm of a kicker post is left solid, so the post stands on
  // plate that joins the rest (a keep-out disc in the middle of a window would leave it an island)
  kr = kp_r + 3;
  keep = [for (s = [-1, 1]) [x_kp, yk + s*k_a]];
  if (y1 > y0 && cw > 12 && ch > 12)
    for (i = [0:nx-1], j = [0:ny-1]) let(cx = x0 + i*(cw + window_rib), cy = y0 + j*(ch + window_rib))
      if (len([for (p = keep) if (p[0] > cx - kr && p[0] < cx + cw + kr && p[1] > cy - kr && p[1] < cy + ch + kr) 1]) == 0)
        translate([cx, cy, -plate_t - 1])
          linear_extrude(plate_t + 2) offset(r = 3) offset(delta = -3) square([cw, ch]);
}

// rectangle from x = 0 to d, hw either side of y = 0, with its two corners at x = d rounded (rf: the
// radius of the two at x = 0)
module round_back_2d(d, hw, r, rf = 0) {
  intersection() {
    translate([0, -hw]) square([d, 2*hw]);   // (a panel thinner than 2r: the circles reach behind it)
    hull() {
      if (rf > 0) for (s = [-1, 1]) translate([rf, s*(hw - rf)]) circle(rf);
      else translate([0, -hw]) square([d - r, 2*hw]);
      for (s = [-1, 1]) translate([d - r, s*(hw - r)]) circle(r);
    }
  }
}

module housing() {
  difference() {
    union() {
      intersection() {
        union() {
          translate([0, -y_ho, -plate_t]) cube([Dh, 2*y_ho, plate_t]);
          for (m = [0,1]) mirror([0, m, 0]) rotate([90,0,90]) linear_extrude(Dh) rail_profile();
        }
        translate([0, 0, z_hbot - 1]) linear_extrude(1 - z_hbot) round_back_2d(Dh, y_ho, corner_h);
      }
      kick_posts();
    }
    groove_cut();
    screw_holes();
    // (window_band leaves the cells under the kicker posts solid)
    if (plate_windows) plate_windows();
  }
}

// ---- drawer (use orientation, closed position)
// the outside of the box and its lips, with the back corners rounded (and the front ones if no panel covers
// them). On the lips' 45° underside the
// corners step outward with the lips, so they need no support; they also lead the lips into the housing.
module drawer_outside() {
  z0 = z_rim - lip_edge - lip;  z1 = z_rim - lip_edge;   // lips' 45° underside
  module walls_2d() { let(r = min(corner_d, 1.5*wall)) round_back_2d(Dd, y_wo, r, panel_t > 0 ? 0 : r); }   // the wall stays solid at the corner
  module lips_2d()  { round_back_2d(Dd, y_wo + lip, corner_d, panel_t > 0 ? 0 : corner_d); }
  translate([0, 0, z_bot]) linear_extrude(z0 - z_bot + eps) walls_2d();
  hull() {
    translate([0, 0, z0]) linear_extrude(eps) walls_2d();
    translate([0, 0, z1]) linear_extrude(z_rim - z1) lips_2d();
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

// ---- the cassette's parts, all standing on its tray (top at z_mf)
z_c0 = z_mf - eps;                              // where they start, just into the tray
module latch_pocket() {   // U-shaped guard: front partition + two side walls to the back wall
  pt = 1.2;
  translate([pocket_x0, pocket_y0, z_c0]) cube([pt, pocket_y1 - pocket_y0, z_rim - z_c0]);
  for (y = [pocket_y0, pocket_y1 - pt]) translate([pocket_x0, y, z_c0]) cube([Dd - wall - pocket_x0 + eps, pt, z_rim - z_c0]);
}

module latch_pivot() {   // shoulder the hub sits on, and the post it turns on
  translate([x_pv, yb, z_c0]) {
    cylinder(d = arm_post_d + 3, h = z_arm - z_c0);
    cylinder(d = arm_post_d, h = z_rim - 0.8 - z_c0);
    translate([0, 0, z_rim - 0.8 - z_c0 - eps]) cylinder(d1 = arm_post_d, d2 = arm_post_d - 1, h = 0.5);
  }
}

module latch_tip_support() {   // arc wall under the pin that the arm slides on, so it can't droop
  translate([x_pv, yb, z_c0]) rotate([0, 0, -phi_l - 6])
    rotate_extrude(angle = phi_l + phi_r + 12, $fn = 96)
      translate([arm_r - 1.2, 0]) square([2.4, z_arm - z_c0]);
}

// latch band posts: spools whose 45° flares above and below keep the band at arm mid-height
module band_spool(x, y) {
  r = cpost_d/2;  f = spool_fl;  zt = z_tun - z_c0;
  translate([x, y, z_c0]) rotate_extrude($fn = 32)
    polygon([[0, 0], [r + f, 0], [r + f, zt - 1.5 - f], [r, zt - 1.5], [r, zt + 1.5],
             [r + f, zt + 1.5 + f], [0, zt + 1.5 + f]]);
}

module latch_band_posts() {
  band_spool(x_bpost, yb);                                   // behind the arm tip
  hull() for (s = [-1,1]) band_spool(x_sp, yb + s*(cband_spread/2 - cpost_d/2));   // spreader
}

// kicker, drawer side. The notch: where the posts run (from x_kp out through the back wall) and
// where the band's strands run from them to the nose corners when closed, plus everything behind the
// drawer, with the nose corners rounded (k_rc) where the band wraps them. Cut from just under the
// posts' bottom up through the rim.
module kick_cut_2d() {
  offset(r = -k_rc) offset(r = k_rc) union() {
    for (s = [-1, 1]) hull() {
      translate([x_kp, yk + s*k_a]) circle(r = k_rp);
      translate([Dd + 3, yk + s*k_a]) circle(r = k_rp);
      translate([Dd, yk + s*k_n]) square(eps, center = true);
      translate([Dd + 3, yk + s*k_n]) square(eps, center = true);
    }
    translate([Dd, yk - k_a - k_rp]) square([10, 2*(k_a + k_rp)]);
  }
}
module kick_notch() { translate([0, 0, z_knb]) linear_extrude(z_rim - z_knb + 1) kick_cut_2d(); }
// the bays: a front wall and an outer wall around each post's notch, so nothing in the drawer sits
// where the posts go (the pocket's side wall and the back wall close them off)
module kick_bays() {
  for (s = [-1, 1]) let(y0 = yk + s*k_n, y1 = yk + s*(k_a + k_rp + k_bw)) {
    translate([k_xf, min(y0, y1), z_c0]) cube([k_bw, abs(y1 - y0), z_rim - z_c0]);
    translate([k_xf, min(y1, y1 - s*k_bw), z_c0]) cube([Dd - wall - k_xf + eps, k_bw, z_rim - z_c0]);
  }
}
// the latch cassette: the latch pocket, pivot, tip support and band posts and the kicker bays, on a
// tray at z_mf, printed flat on its tray; its back wall fills the notch in the drawer's
// back and is the kicker's nose. An ear either side sits
// against the back's inner face: bolted through it (cassette_mount captive_nut or normal, on
// vertical slots so its height can be set flush with the rim), or for mortise just a stop, the back
// wall then being a dovetail in the notch that rests on the notch's floor.
cb_m = cm_nut ? nut_ac/2 + 0.8 : cb_hole/2 + 1.5;   // slot ends this far inside the ear's top and bottom
cb_z0 = z_cb + cb_m;  cb_z1 = max(cb_z0, z_rim - cb_m);
c_bolt_z = (cb_z0 + cb_z1)/2;                   // where the bolts go with the cassette flush
mt_t = cm_mort ? tan(mortise_angle) : 0;        // mortise: the dovetail's sides widen this much per mm outward
// the cassette's back wall in plan (x, y), c wider each side and ext longer at both faces (for the
// notch): a dovetail for mortise, else a plain block
module c_back_2d(c = 0, ext = 0) {
  x0 = Dd - wall - ext;  x1 = Dd + ext;
  h0 = (yc1 - yc0)/2 + c - ext*mt_t;  h1 = (yc1 - yc0)/2 + c + (wall + ext)*mt_t;
  polygon([[x0, yk - h0], [x0, yk + h0], [x1, yk + h1], [x1, yk - h1]]);
}
module cassette() {
  ys0 = yc0 - ear_w;
  difference() {
    union() {
      latch_pocket(); latch_pivot(); latch_tip_support(); latch_band_posts(); kick_bays();
      // tray: only under the walls' outline – the pocket, and the two kicker bays beside it
      translate([pocket_x0, pocket_y0, z_cb]) cube([Dd - wall - pocket_x0 + eps, pocket_y1 - pocket_y0, ct_t]);
      translate([k_xf, yc0, z_cb]) cube([Dd - wall - k_xf + eps, yc1 - yc0, ct_t]);
      translate([0, 0, z_cb]) linear_extrude(z_rim - z_cb) c_back_2d();                       // back wall
      for (y = [ys0, yc1]) translate([Dd - wall - ear_t, y, z_cb]) cube([ear_t, ear_w, z_rim - z_cb]);   // ears
    }
    kick_notch();
    if (!cm_mort) for (y = [ys0 + ear_w/2, yc1 + ear_w/2]) {
      // bolt slot through the ear
      hull() for (z = [cb_z0, cb_z1])
        translate([Dd - wall - ear_t - 1, y, z]) rotate([0, 90, 0]) cylinder(d = cb_hole, h = ear_t + 2, $fn = 16);
      // captive nut: a hex slot from the ear's inner face, the nut's flats against its sides so it can't
      // turn but can slide up and down with the bolt
      if (cm_nut) hull() for (z = [cb_z0, cb_z1])
        translate([Dd - wall - ear_t - 1, y, z]) rotate([0, 90, 0]) cylinder(d = nut_ac, h = 1 + nut_t, $fn = 6);
    }
  }
}
// the notch in the drawer's back for the cassette and the bolt
// holes. Bolted: 0.5 mm clear each side and 1 mm under the cassette (its height is set on the
// slots). Mortise: the dovetail, mortise_clr clear, its floor the cassette's bottom.
wn_c = cm_mort ? mortise_clr : 0.5;
wn_z = cm_mort ? z_cb : z_cb - 1;
module c_notch_cut() {
  translate([0, 0, wn_z]) linear_extrude(z_rim - wn_z + 1) c_back_2d(wn_c, 1);
  if (!cm_mort) for (y = [yc0 - ear_w/2, yc1 + ear_w/2]) translate([Dd - wall - 1, y, c_bolt_z]) rotate([0, 90, 0])
    cylinder(d = cb_hole, h = wall + 2, $fn = 16);
}
// screw holes for a wood face, countersunk on the inside: the heads sit 0.3 mm below the surface, or
// stick out a little if the front is too thin to leave 1 mm under them
module wood_face_holes() {
  csk = wf_r - wf_d/2;                              // depth of the 45° countersink
  x0 = wall - min(0.3, wall + panel_t - csk - 1);   // where it is full size
  for (y = wf_ys, z = wf_zs) translate([0, y, z]) rotate([0, 90, 0]) {
    translate([0, 0, -panel_t - 1]) cylinder(d = wf_d, h = wall + panel_t + 2);
    translate([0, 0, x0 - csk]) cylinder(r1 = wf_d/2, r2 = wf_r, h = csk);
    translate([0, 0, x0 - eps]) cylinder(r = wf_r, h = 2);
  }
}
// the wood itself, for the views, as big as the printed front (as the housing, without one)
module wood_face_board() {
  translate([-panel_t - wood_face_t, -panel_w/2, z_bot]) cube([wood_face_t, panel_w, panel_h]);
}

// drawer body: a plain box with the lips and the front panel, and a notch in its back wall for the
// cassette (and its 2 bolt holes, unless cassette_mount = mortise)
module drawer_body() {
  difference() {
    union() {
      drawer_outside();
      // front panel – also the closing stop against the housing face
      if (panel_t > 0) translate([eps, 0, z_bot]) mirror([1, 0, 0]) linear_extrude(panel_h) round_back_2d(panel_t + eps, panel_w/2, min(corner_d, 0.75*panel_t));
    }
    translate([wall, -Wd/2 + wall, z_bot + floor_t]) cube([Dd - 2*wall, Wd - 2*wall, Hd]);
    c_notch_cut();   // the cassette's notch and bolt holes
    if (wood_face) wood_face_holes();
  }
}
// assembled (closed, drawer coordinates): the body with the cassette in it
module drawer() { drawer_body(); cassette(); }

// ---- all parts in print orientation, side by side on the bed
module print_layout() {
  gap = 10;
  hw_h = y_ho;                                         // housing half-width
  hw_d = max(panel_w/2, y_wo + lip);                   // drawer half-width (front panel / lips)
  cw = yc1 - yc0 + 2*ear_w;                            // cassette width with its ears
  y1 = -(hw_h + gap);                                  // top of the drawer's row, under the housing
  yc = y1 - 2*hw_d - gap;                              // top of the cassette's row
  rotate([180,0,0]) housing();                                     // desk face down
  translate([0, y1 - hw_d, -z_bot]) drawer_body();                 // floor down
  translate([-pocket_x0, yc - (yc1 + ear_w), -z_cb]) cassette();   // tray down
  translate([hub_d/2, yc - cw - gap - hub_d/2, 0]) latch_arm();    // pin up
}

// ============================================================= output
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
// on the straight run (and its catch), and at rest out of the plate
function v_free(u) = path_v(mouth_path, u);
function v_exit(u)  = u >= 0 ? path_v(cam_paths[3], u) : v_free(u);   // going out (after release)
function v_entry(u) = u >= 0 ? path_v(cam_paths[0], u) : v_free(u);   // going in
// Animation, one push-push cycle per run of $t: latched (pause) -> push -> released, out along the
// exit path to where the ejector leaves it (ej_rest; pause) -> pulled to the pull-out catch (pause) ->
// pulled up over it until the pin is out of the plate (pause) -> in over the catch's ramp and along
// the entry path to the stop -> let go, back into the notch. Without the catch it goes
// back in from where the ejector leaves it.
// Phases are [u from, u to, the pin's v at u, length]. Lengths are in mm of travel (pauses 12), so the
// drawer moves at a steady pace, but at most 120 so the latch isn't over in a flash on a deep drawer.
an_umin = u_stop - ej_rest;
an_uc = min(an_umin, catch_uf);                 // meets the catch
an_uo = -x_cam0 - 4;                            // pin out of the plate
an_uin = catch ? an_uo : an_umin;               // where it is pushed back in from
v_push2 = function(u) path_v(cam_paths[2], u);
v_out_f = function(u) v_exit(u);
an_go = function(a, b, f) [a, b, f, min(120, abs(b - a))];
an_wait = function(u, f) [u, u, f, 12];
an_ph = concat(
  [an_wait(u_a, v_push2), an_go(u_a, u_stop, v_push2), an_go(u_stop, an_umin, v_out_f), an_wait(an_umin, v_out_f)],
  !catch ? [] : [an_go(an_umin, an_uc, v_out_f), an_wait(an_uc, v_out_f), an_go(an_uc, an_uo, v_out_f), an_wait(an_uo, v_out_f)],
  [an_go(an_uin, u_stop, function(u) v_entry(u)), an_go(u_stop, u_a, function(u) path_v(cam_paths[1], u))]);
an_tot = sum([for (p = an_ph) p[3]]);
function an_pin(t) = an_at(t * an_tot);
function an_at(T, k = 0) = let(p = an_ph[k]) k < len(an_ph) - 1 && T >= p[3] ? an_at(T - p[3], k + 1) :
  let(u = p[0] + (p[1] - p[0]) * (0.5 - 0.5*cos(180 * max(0, min(1, T / p[3])))), v = p[2]) [u, v(u)];
// static assembly: the slider, with the pin on the exit path (the drawer was released and pulled out)
function slider_pin() = let(u = u_stop - (Dd - 15) * max(0, min(100, assembly_open_pct)) / 100) [u, v_exit(u)];

// ---- energy map (part = energy_map). Each band is modelled as a linear spring: tension =
// strength * (stretched length / relaxed length - 1), so its stored energy is
// strength * (L - C)^2 / (2 C) for loop path L and relaxed circumference C (0 when slack).
// The drawer can only run by itself where the total goes downhill.
function band_e(n, L, C) = L > C ? n * pow(L - C, 2) / (2*C) : 0;
// latch band: the two strands run spreader -> arm tip -> back post; the tip pushes a strand out
// where it reaches past the strand's straight line. s = pin's sideways offset from rest.
function e_latch(v) = band_e(latch_band_n, el_len(v - cam_rest_v), cband_loop/1.5);   // the band the console recommends (stretched 1.5x on straight strands)
function el_len(s) = let(ph = asin(max(-1, min(1, s / arm_r))),
    tx = x_pv + arm_r*cos(ph), ty = arm_r*sin(ph))
  cband_loop - 2*cband_len + sum([for (k = [-1, 1]) let(P = [tx, ty + k*arm_w/2],
    S = [x_sp, k*cband_spread/2], B = [x_bpost, k*cpost_d/2])
    k*P[1] > band_y(tx) ? norm(P - S) + norm(B - P) : cband_len]);
function sum(a, i = 0) = i >= len(a) ? 0 : a[i] + sum(a, i + 1);
// ejector (the kicker, kicker_band_n), with the drawer x mm out
function e_eject(x) = band_e(kicker_band_n, k_len(Dd - x, k_a), 2*k_band);
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
  x_end = min(catch_out, max(ej_rest, u_stop + 3));   // as far as the pull-out catch
  out = em_run(function(x) v_out(x), x_end);
  ret = em_run(function(x) v_notch(x), x_lat);
  echo(str("ENERGY MAP: latch band ", latch_band_n, " N, ejector band ", kicker_band_n,
           " N (strength = pull to stretch to 2x). Energies in mJ (N*mm); push in N"));
  pts = [
    ["latched (pin in the notch)",                 x_lat,           v_n],
    ["pushed to the stop, released",               0,               v_le],
    ["exit curve starts",                          u_stop - u_4s,   v_out(u_stop - u_4s)],
    ["arm swung furthest (left channel)",          u_stop - u_4e,   v_l],
    ["left channel ends, band starts to help",     ej_free,         v_l],
    ["pin leaves the groove (reset for the next close)", u_stop,  0],
    ["kicker lets go", ej_rest, v_out(ej_rest)]];
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
  {
    c = k_coast(kicker_band_n, d_mass);
    echo(str("  kicker with a ", kicker_band_n, " N band: gives ", r1(kicker_band_n*k_e1), " mJ; an empty drawer (~",
             round(d_mass), " g) ", c > 0 ? str("coasts ~", round(c), " mm past the ", k_s, " mm push (~", round(k_s + c),
             " mm open", k_thrown(kicker_band_n) > 0 ? ", WARNING: that throws it out – use a weaker band" : "", ")")
             : "stops before the push ends", "; it still resets with up to ~", round(max(0, k_maxg(kicker_band_n) - d_mass)),
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
    // groove walls as a 0.8 mm outline, at the plate's underside where the pin runs, cut off at the
    // plate's front edge so it shows the mouth's real shape
    translate([0, 0, -plate_t]) linear_extrude(1) intersection() {
      difference() { offset(r = 0.8) groove_2d(); groove_2d(); }
      translate([0, -y_ho]) square([Dh, 2*y_ho]);
    }
    kick_posts();
  }
  translate([-open, 0, 0]) {
    if (dmode == "ghost") %drawer(); else color("Orange") drawer();
    if (wood_face) { if (dmode == "ghost") %wood_face_board(); else color("BurlyWood") wood_face_board(); }
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
  // kicker band: its two strands straight across between its posts, or, once the drawer's back
  // reaches them, from the posts round the back of the latch pocket
  color("Black") let(X = Dd - open + 0.6)
    for (xj = [x_kp - kp_d/2 - 0.5, x_kp + kp_d/2 + 0.5]) let(
      P = X > xj ? [[xj, yk - k_a], [X, yk - k_n], [X, yk + k_n], [xj, yk + k_a]] : [[xj, yk - k_a], [xj, yk + k_a]])
      for (i = [0:len(P)-2]) hull() for (p = [P[i], P[i+1]]) translate([p[0], p[1], z_kb]) sphere(d = 1.2, $fn = 8);
}

if (part == "print_layout" || (part == "assembly" && !$preview)) print_layout();
else if (part == "assembly") scene(slider_pin(), "solid", "solid");
else if (part == "animation") scene(an_pin($t), "groove", animation_drawer);
else if (part == "energy_map") { energy_map(); cube(1); }
else if (part == "housing") rotate([180,0,0]) housing();   // desk face down on the bed
else if (part == "drawer")   translate([0, 0, -z_bot]) drawer_body();   // floor on the bed
else if (part == "cassette") translate([0, 0, -z_cb]) cassette();       // tray on the bed
else if (part == "arm")      latch_arm();                               // flat on the bed, pin up
else if (part == "cam_paths") {
  // machine-readable dump for the latch simulator
  echo(str("CAM r_eff=", r_eff, " pin_r=", pin_d/2, " u_stop=", u_stop, " U=", U, " u_a=", u_a));
  echo(str("ARM r=", arm_r, " rest=", cam_rest_v));
  echo(str("BEND tightest pin-path radius inside a path: ", cam_min_r, " mm (r_eff ", r_eff, "; path ends excluded: those are the cusps)"));
  for (p = cam_paths) echo(str("PATH ", p));
  cube(1);
}
