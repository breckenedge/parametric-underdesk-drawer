# Parametric Under-Desk Drawer (push-to-open)

An OpenSCAD drawer that screws under a desk and prints with no supports. Push the front to latch it; push again and a rubber band pops it open.

`underdesk_drawer.scad`: open it in OpenSCAD (nightly, with the Manifold backend). Set the size in the Customizer, then pick `part`.

`part = assembly` shows the drawer assembled in F5 preview; F6 renders all the parts laid out for printing (`print_layout` shows that layout in F5). The `assembly_open_pct` slider pulls the drawer out (100% leaves 15 mm in the housing). The pin stays in the groove on its way-out path, as after a release, and the latch arm swings to match.

`part = animation` animates one full latch cycle: latched → push → pops out to where the ejector leaves it → pushed back in → latched again. The pin follows the groove, the arm swings with it, and the rubber bands are drawn too. The housing is drawn as just its groove outline and kicker posts, so nothing hides the arm. `animation_drawer` can be `solid` or `ghost`. Press F5, then open the Animate panel: Window → Animate in recent OpenSCAD (View → Animate in 2021.01). Set FPS and Steps there, for example 15 and 100 (more Steps for deep drawers).

| part | print orientation | notes |
|---|---|---|
| `housing` | desk face down on the bed (already exported that way) | slide ledges, latch groove, screw holes, the two kicker posts |
| `drawer` | floor on the bed | a plain box: lips, front panel, and a notch in the back wall for the cassette (with its bolt holes) |
| `cassette` | tray on the bed | latch pocket, the arm's pivot post and tip support, latch band posts and kicker bays on one flat tray; its back wall is the kicker's nose |
| `arm` | flat on the bed, pin up | rigid latch arm that carries the pin |
| `lip_strip` | cap on the bed (already exported that way); print 2 | wood drawer only: the 45° lip, a cap over the side board's top edge, a screw flange inside |
| `stop_gauge` | flat | wood drawer only: sets the two stop screws |

With `drawer_build = wood` the drawer is a plywood box instead (see [Wood drawer](#wood-drawer)), and `print_layout` lays out the housing, two lip strips, the cassette, the arm and the gauge.


## How it works
- **Slide:** 45° lips on the drawer rest on 45° ledges in the housing. This works like a dovetail. It centres the drawer side to side, and both parts print with no overhang steeper than 45°. If the print comes out a little wider or narrower, the drawer just rides slightly higher or lower.
- **Latch:** a push-push "heart cam" groove is cut into the housing plate. The pin that runs in it sits on a rigid arm in a pocket on the cassette, at the back centre of the drawer. The arm swings sideways on a post at its front end, so the cam can push it sideways without it tipping or jamming, and the push of the latch goes straight along the arm into the post. One rubber band is stretched lengthwise around a spreader in front of the arm's hub and a post behind its tip, with the arm sitting between its two strands. When the arm swings, its rounded tip pushes one strand out like a bowstring, and the band pulls it back to centre. At rest both strands press lightly on the tip, so there's no dead zone in the middle. No printed part has to flex. The pin moves on a slight arc, so the groove is drawn with that correction. The latch is centred, so it pulls straight and doesn't twist the drawer on the slide; `latch_y` shifts it sideways in mm (+ = left) if you need to. The cycle is: push in → latch (the drawer sits about 7.5 mm proud) → push about 5 mm or more → release. On the way out after release, the groove steers the pin back across on a smooth S-curve (no corners, at most about 36° off straight) rather than a sharp 45° bend, so the drawer doesn't stutter there. Every other bend in the groove is rounded too, on arcs of 1.4–3 mm radius (the pin-centre path, as in the prior art below). The only sharp points left are where the groove's paths meet: the notch the pin rests in, the two stroke ends, and the mouth. Those points decide which way the pin goes, so they stay sharp. That swing stretches the latch band, so the curve does most of it early, while the ejector still pushes hard, and the last stretch to the groove's mouth lets the latch band push the drawer out instead.
- **Cassette:** the whole latch mechanism and the kicker's bays on one printed tray. It's a separate part from the drawer, so it prints flat with nothing hanging in the air. It sits in a notch in the top of the drawer's back, with its tray just under the arm; its back wall fills the notch, flush with the outside, and is the nose the kicker band pushes on. The latch and kicker forces stay inside the cassette: the band pushes the nose, and the pin holds the arm, which is on the same part. An ear on each side sits against the inside of the drawer's back. `cassette_mount` picks how it's held:
  - `captive_nut` (default): a bolt from outside through the back into a nut held in a hex slot in each ear. The slot keeps the nut from turning and lets it slide up and down, so you can set the cassette's height before tightening. `cassette_bolt` sets the size (M2.5, M3, M4, M5; default M3).
  - `normal`: the same bolts through vertical slots in the ears, with loose nuts.
  - `mortise`: no hardware. The cassette's back wall is a dovetail (`mortise_angle`, default 20° off square, with a `mortise_clr` gap) that drops into a matching notch and rests on its floor. The dovetail stops it moving forward, and the ears stop it moving back. The notch floor sets its height, so on a wood drawer cut the notch depth exactly.
- **Pull-out catch:** the groove's straight run to the housing's front has a jog in it, so an open drawer stops before it comes right out. It needs no extra part: the latch arm and its band are the spring. Pulling takes the pin up a steep face (`catch_angle`, 60°); pushing the drawer back in takes it up a 45° ramp. With a 2 N latch band that's roughly 3 N to pull it out and 1.3 N to put it back, and the console prints the estimate for your settings. It's a nudge, not a lock: a firm pull or a fast, heavy drawer goes past it. The drawer stops with about 35 mm of its back still in the housing, so a short drawer loses a good part of its opening (the smallest stops 31 mm out of 66). `catch_h = 0` leaves it out.
- **Ejector, the kicker:** one short band on two posts that hang from the housing plate, one on each side of the cassette. It is always a little stretched around them (1.2× with the drawer open), so it is never slack. It never hooks onto the drawer, so there is nothing for it to fall off. Over the last `band_stroke` (32 mm) of closing, the cassette's back pushes the middle of the band back into a V; released, the band pushes the drawer out again and lets go of it. Each post runs in a notch cut into the top of the cassette's back (about 8 mm deep), inside a small walled bay beside the pocket so nothing in the drawer sits in its way. The band has to still be pushing when the latch pin leaves its groove, about 26 mm out. Otherwise the drawer stops with the pin still on its way out and needs a pull before it latches again. So the stroke is never less than about 31 mm.
  - The cassette is as wide as the posts are apart, so the band is kept short. The console picks the shortest ½" length (1.5"–6") that a band you can buy (about 2 N or more) suits for the drawer's estimated weight, and says what strength that is. Use a band about that strong and set `kicker_band_n` to it. The aim is that an empty drawer opens about twice the stroke.
  - The band always sits on its posts at the same 1.2× stretch, so a shorter band means posts closer together. The closed stretch is the same 32 mm stroke whatever the band, so on a shorter band it's a bigger share of its length. It stretches further (up to 2.5× at most) and stores more energy for the same strength. So a short band needs a weaker rubber band, and a heavier drawer can use a shorter one. Printed drawers, M3 captive nuts:

    | drawer (interior, mm) | rough weight | band | post spacing | stretched closed | band strength | cassette width |
    |---|---|---|---|---|---|---|
    | 120 × 100 × 30 | 119 g | 3" | 82 mm | 1.6× | 1.7 N | 112 mm |
    | 200 × 150 × 40 | 220 g | 3" | 82 mm | 1.6× | 2.9 N | 112 mm |
    | 400 × 200 × 20 | 318 g | 2.5" | 67 mm | 1.8× | 2.6 N | 97 mm |
    | 300 × 300 × 60 | 514 g | 2" | 52 mm | 2.1× | 2.4 N | 81 mm |

  - Once the band lets go, mostly friction stops the drawer; the pull-out catch only takes a little off a drawer that gets that far. The console warns if your band could throw the empty drawer out, and says what strength it would rather have. Its numbers are rough (estimated weight, PLA-on-PLA friction 0.3), so try it before filling the drawer. A heavier load stops it shorter; if it stops before the latch resets, a short pull resets it.
  - Small, light drawers are the weak spot. The smallest one (84 × 62 × 17 mm, about 68 g) only has room for a 2" band, and that wants a band of about 0.4 N, weaker than you can usually buy. Use the thinnest, weakest band you have, and expect the drawer to pop out further than a bigger one would.

## Wood drawer
Set `drawer_build = wood` to cut the drawer box from plywood and print only the parts that have to be precise. The housing and the cassette don't change. Set `wood_t` to your plywood's measured thickness (plywood is often a little under its nominal size) and `wood_bottom_t` to the bottom's.

- **The box:** a bottom under everything, two sides standing on it, a back between the sides, and a front panel across the front of all of them. The front panel is wide enough to cover the housing's front. The console prints the cut list, including the notch in the top of the back board for the cassette (with its two bolt holes, or for `mortise` the dovetail's widths). The boards stop 1.6 mm under the rim, because the printed parts form the rim.
- **Lip strips (2, the same part):** a U that fits over each side board's top edge. The 45° lip is outside, a cap sits on top, and a flange runs down the inside with small countersunk screws into the board. Glue the strip on with the board pressed against the lip side. The slide is still plastic on plastic, so the wood's finish and movement don't affect it. The strips run from the housing's front to the back of the box; if they're longer than your printer bed, print them in pieces and butt them end to end.
- **Cassette:** the same part as on a printed drawer (see [How it works](#how-it-works)), with its back wall as thick as the plywood.
- **Pin height:** the pin only reaches about 2.2 mm into its groove, so the cassette has to sit at the same height as the lips. Do the final tightening of the strips and the cassette upside down on a flat table: the strips' caps and the cassette's top all rest on the table, so they end up in one plane whatever the wood does. With `mortise`, the notch floor sets the cassette's height instead.
- **Closing stop:** on the printed drawer the front panel itself hits the housing, and the pin then stops 1.2 mm short of the end of its groove. A wood box isn't that accurate, so the stop is two pan-head screws in the back of the front panel that hit the housing's rails. The front panel sits `stop_bump` (3 mm) in front of the housing, and the screws stick out by about that much. To set them, latch the drawer. Then turn the screws out until they just touch the printed gauge (`stop_gauge`, as thick as the latched drawer sits proud, about 7.4 mm) held against the housing's front. The pin in its notch sets the latched position, so this is accurate even if the box isn't.
- **Ejector:** the kicker, sized for the box's weight (plywood is taken as 0.6 g/cm³). A 200 × 150 × 40 mm drawer gets a 2.5" band wanting about 2.4 N (about a 1/16" band) and a 97 mm wide cassette. The strips' flanges also have to fit beside the cassette, so a wood drawer needs an interior width of about 87 mm or more (M3 captive nuts; less with `mortise`). Narrower, the console warns and the wood parts are left out; the housing and the arm still render.
- **Hardware for a wood drawer:** wood glue or epoxy for the strips, a few small countersunk wood screws (about 2.5–3 mm × 10 mm) for their flanges, 2 bolts with nuts for the cassette (about `wood_t` + 8 mm long; none for `mortise`), and 2 pan-head wood screws (about 3.5 mm) for the stop.

## Hardware
- Countersunk wood screws: 4 for small drawers, more for long ones (the console prints the count; `screw_spacing` sets the most space allowed between screws along each side, default 100 mm, so a 200 mm deep drawer gets 6). #8 / 4 mm by default (pick #6, #8, #9 or #10 with `screw`). Length = desk thickness minus a few mm + 5 mm (the plate)
- Ejector: 1 short rubber band for the kicker, its length and strength picked for the drawer. The console says which
- 1 rubber band for the latch (size printed in the console; default: about 77 mm around / 39 mm flat, e.g. a #10 to #12 band, or a smaller one doubled)
- Cassette: 2 bolts and nuts, M3 by default (about the back wall's thickness + 8 mm long, so 10–12 mm on a printed drawer), unless `cassette_mount = mortise`

## Print settings
- No part flexes, so PLA or PETG both work for every part.
- Print the arm with at least 3 perimeters so the pin is solid.

## Minimum sizes
The Customizer won't go below **84 mm wide, 62 mm deep, 17 mm tall** (interior). The width is the room for the kicker's posts and the cassette's ears on each side of the latch. That's with M3 captive nuts: bigger bolts need a little more, and `mortise` a little less (about 80 mm). The depth comes from the latch arm and its band (spreader to back post), and the height leaves 5 mm of back wall under the cassette's notch.

## Install
1. Screw the housing to the desk. All screws are reachable from below with the drawer out.
2. Put the cassette in its notch in the drawer's back. `captive_nut`: push a nut into each ear's hex slot and bolt through from outside. `normal`: bolt through with loose nuts on the inside. `mortise`: slide it straight down into the dovetail. Set its top flush with the rim before tightening.
3. Stretch the latch band around the spreader (front of the pocket) and the post behind it, so it forms a long loop. Spread the strands apart and drop the arm's hub onto the pivot post between them; the band sits on either side of the arm's rounded tip. Nothing needs threading, so a doubled band is just as easy.
4. Stretch the kicker band around both posts (between their flares) before you put the drawer in. It stays there, even when you take the drawer out.
5. Slide the drawer in. The funnel at the plate's front edge guides the pin into its groove, and the drawer clicks over the pull-out catch. To take it out again, pull firmly past the catch.
6. Wood drawer: set the two stop screws with the gauge (see [Wood drawer](#wood-drawer)) the first time it latches.

## Tuning (Customizer)
- Slide too tight or too loose: `slide_clr`, `side_clr`.
- Arm sticks or wobbles on its pivot: `arm_clr`. Latch feels stiff or weak: use a looser or tighter latch band.
- Latch won't engage or release reliably: `pin_clr`. If you change the cam numbers, re-check them with `tools/camsim.ps1` (see below).
- Drawer stops short and needs a pull before it latches again: check `part = energy_map` for an uphill stretch, and keep `band_stroke` at least what the latch needs.
- Ejection too weak or too violent: set `kicker_band_n` to your band's strength and use the length the console picks; `part = energy_map` estimates how far the empty drawer coasts. A shorter `band_stroke` also gives less push.
- Pull-out catch too weak or too stiff: raise or lower `catch_angle` a few degrees at a time (friction makes it climb fast; past about 70° it may not let go at all), or use a stronger latch band. `catch_h` changes it less.
- Mortise cassette too tight or loose in its notch: `mortise_clr`.

## Energy map
A drawer only runs by itself while the rubber bands' total stored energy keeps going down, because a band won't climb back up an energy hill. `part = energy_map` prints that total in the console (no geometry) through one cycle. It works each band's stretched length out from the real geometry: the latch band's two strands around the arm tip, and the kicker's band from its posts round the back of the cassette. It also estimates how far the empty drawer coasts after the band lets go, and how much it can carry and still reset. It lists:
- the latch band's and the ejector's energy at the key points (latched, released, the exit curve, the arm's furthest swing, the pin leaving the groove, the kicker letting go);
- the two runs that have to happen on their own: released → open, and let go after the first push → into the notch. Each is either "downhill all the way", with the smallest net push left (in N) and the push as the pin leaves the groove, or a WARNING naming each uphill stretch, where the drawer stops unless momentum carries it.

Set `latch_band_n` (Energy map section) and `kicker_band_n` (Rubber band ejector) to your bands' strength: the pull in N it takes to stretch one to twice its length (100 g ≈ 1 N). It treats a band as a linear spring with no friction, so read the numbers as a comparison, not exact forces. For example, an old 25 mm stroke showed uphill from 25.5 to 28.6 mm out: the band was relaxed before the pin left the groove, which is why the drawer had to be pulled out the last bit before it would latch again.

## Latch verification
`tools/camsim.ps1` sends a finite-size pin through the real groove geometry over repeated push/release cycles, with a strong, a weak and no centring spring (the latch band). It models the arm: the pin swings on an arc, as it does on the real part. Dump the geometry, then run it:
```
openscad -o dump.echo -D 'part="cam_paths"' underdesk_drawer.scad
powershell -ExecutionPolicy Bypass -File tools\camsim.ps1 -dump dump.echo
```
Results for the current geometry:
- Latch and release work with both the strong and the weak spring. With no spring at all it stays latched, which is why the latch band is needed.
- With the panel stop off by ±0.8 mm, it still works.
- A partial push from latched (1.5 mm or 4 mm) re-latches; 5.5 mm releases. The catch is deep, so the spring alone can never pull the pin out of the notch.
- `tools/camsim_rest_offset.ps1` shows it still works if the arm comes to rest off-centre by -0.25…+2 mm (pivot friction, an uneven band). The band aims it at about the middle of that window.
- `tools/cammargin.ps1` checks the one thing the slow-motion simulation can't: momentum. On the way out after the first push, the band pulls the pin toward the exit side. A fast-swinging arm, a drawer that bounces, or play in the pivot can carry it over the catch, especially when the unit isn't level, because then nothing presses the arm onto its post to damp it. The tool finds the smallest amount the drawer would have to move back in, part-way through that return, for the pin to skip the catch: **2.3 mm** (the earlier groove had 0.66 mm, and 2.1 mm before its corners were rounded). The return path drops straight for a while before turning toward the notch, and the exit ramp climbs higher.
  ```
  powershell -ExecutionPolicy Bypass -File tools\cammargin.ps1 -dump dump.echo
  ```

## Prior art
Notes from patents on commercial push-push latches (read November 2026), and how this design compares. None of them give dimensions, so every number in this design still comes from the tools above.
- **Southco, US 6247733 (push-push latch with clicker):** a heart-shaped groove cut into a shuttle that pivots freely, off-centre. The incoming pin hits a ramp, which turns the shuttle and steers the pin into the catch. The steering comes from the walls alone: no steps in the floor and no spring on the shuttle. This is the closest relative of this design (here the arm pivots instead of the cam), and it shows that walls alone can steer reliably. Its walls are continuous curves; this groove used to be straight legs meeting at corners, and now it rounds them the same way. A wire-sprung fork clicks as the pin passes, so you hear it latch. This design has nothing like that.
- **Alcon, EP 4687688 A1 (robust push-push connector):** a rigid arm on a pivot carries a pin around a triangular track. It explains that earlier arms, which bent sideways to follow the track, were fragile. So the arm is rigid, and a torsion spring preloads it against one wall of the track at all times, which takes out play and bounce. This design uses the same idea: a rigid arm, with the latch band pressing on its tip even at rest.
- **GM, US 9895969 (push-push latch):** guide ridges in the track floor, with the pin held down onto them by a flexing bridge. The ridges, not the walls, decide which way the pin goes, so a bounce can't send it the wrong way. Lifting the pin above the ridges traps it, which is how this latch locks. The downside is that something has to press the pin onto the floor. This design has no floor steps; `tools/cammargin.ps1` measures how well it resists bounce instead.
- **Alps, US 4916276 (push lock):** the failure it fixes is someone pulling while the latch is engaged. That loads the pin against the groove, and in earlier designs it eventually broke the groove or bent the pin. Its fix is to connect the handle to the latched part through a weaker spring, so a pull moves the handle without loading the pin. In this design a pull on a latched drawer goes straight into the pin. Pulling a stalled drawer was also how the old version had to be reset; since b48a9b1 the ejector keeps pushing until the pin has left the groove, so that pull isn't needed.
- **A printed push latch on MakerWorld (model 2403525)** replaces its plastic actuator arm with a steel paperclip, because a plastic arm that stays bent takes a set over time. In this design no printed part stays bent, and the latch band does the springing. Rubber bands relax with age too, though, so keep the energy map's leftover push comfortable.

**Not yet physically tested.** Expect to tune clearances on the first print.
