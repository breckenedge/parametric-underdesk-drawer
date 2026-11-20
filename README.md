# Parametric Under-Desk Drawer (push-to-open)

An OpenSCAD drawer that screws under a desk and prints with no supports. Push the front to latch it; push again and a rubber band pops it open.

`underdesk_drawer.scad`: open it in OpenSCAD (nightly, with the Manifold backend). Set the size in the Customizer, then pick `part`.

`part = assembly` shows the drawer assembled in F5 preview; F6 renders all three parts laid out for printing (`print_layout` shows that layout in F5). The `assembly_open_pct` slider pulls the drawer out (100% leaves 15 mm in the housing). The pin stays in the groove on its way-out path, as after a release, and the latch arm swings to match.

`part = animation` animates one full latch cycle: latched → push → pops out to where the ejector leaves it → pushed back in → latched again. The pin follows the groove, the arm swings with it, and the rubber bands are drawn too (the back band follows the loops on the drawer's back). The housing is drawn as just its groove outline and band posts, so nothing hides the arm. `animation_drawer` can be `solid` or `ghost`. Press F5, then open the Animate panel: Window → Animate in recent OpenSCAD (View → Animate in 2021.01). Set FPS and Steps there, for example 15 and 100 (more Steps for deep drawers).

| part | print orientation | notes |
|---|---|---|
| `housing` | desk face down on the bed (already exported that way) | slide ledges, latch groove, screw holes, band posts (back band under the side walls; kicker beside the latch) |
| `drawer` | floor on the bed | lips, front panel, latch pocket with the arm's pivot post and band post; back band loops, or the kicker's notches and bays |
| `arm` | flat on the bed, pin up | rigid latch arm that carries the pin |


## How it works
- **Slide:** 45° lips on the drawer rest on 45° ledges in the housing. This works like a dovetail. It centres the drawer side to side, and both parts print with no overhang steeper than 45°. If the print comes out a little wider or narrower, the drawer just rides slightly higher or lower.
- **Latch:** a push-push "heart cam" groove is cut into the housing plate. The pin that runs in it sits on a rigid arm in a pocket at the back centre of the drawer. The arm swings sideways on a post at its front end, so the cam can push it sideways without it tipping or jamming, and the push of the latch goes straight along the arm into the post. One rubber band is stretched lengthwise around a spreader in front of the arm's hub and a post behind its tip, with the arm sitting between its two strands. When the arm swings, its rounded tip pushes one strand out like a bowstring, and the band pulls it back to centre. At rest both strands press lightly on the tip, so there's no dead zone in the middle. No printed part has to flex. The pin moves on a slight arc, so the groove is drawn with that correction. `latch_side` puts the groove and the drawer's mechanism pocket in the centre (default), or as far to the left or right as fits (seen from the front), which leaves one wide open area in the drawer instead of two narrow ones. Centred, the latch pulls straight and doesn't twist the drawer on the slide; off to one side it pulls slightly at an angle, which the dovetail slide holds. `latch_y` adds a fine sideways shift in mm (+ = left). A gap narrower than 12 mm between the pocket and a side wall is closed off, so there's no dust slot. The cycle is: push in → latch (the drawer sits about 7.5 mm proud) → push about 5 mm or more → release. On the way out after release, the groove steers the pin back across on a smooth S-curve (no corners, at most about 36° off straight) rather than a sharp 45° bend, so the drawer doesn't stutter there. Every other bend in the groove is rounded too, on arcs of 1.4–3 mm radius (the pin-centre path, as in the prior art below). The only sharp points left are where the groove's paths meet: the notch the pin rests in, the two stroke ends, and the mouth. Those points decide which way the pin goes, so they stay sharp. That swing stretches the latch band, so the curve does most of it early, while the ejector still pushes hard, and the last stretch to the groove's mouth lets the latch band push the drawer out instead.
- **Ejector:** two layouts, picked automatically:
  - *Back band* (small drawers): one rubber band loops around two posts that hang under the housing walls. Closing the drawer makes its back wall stretch the band. The band is fed through two loops on the drawer's back (short rounded tunnels, flat against the wall and curved top and bottom; where a curve would overhang it runs at 45° instead, with a short flat at the top of the tunnel, so they print without supports), so it stays with the drawer and also stops it: once the drawer's back passes the posts, the band stretches the other way and pulls it back. Released, the drawer settles about `band_stroke` (32 mm) open, and even a strong band can't throw it out further than about twice that, because the band can only give back the energy it stored when the drawer closed. On short drawers the stroke is cut so that stays 15 mm inside the housing, but never below about 31 mm. The band has to still be pushing when the latch pin leaves its groove, about 26 mm out; otherwise the drawer stops with the pin still on its way out and needs a pull before it latches again. On the shortest drawers that leaves only 4 mm on the ledges in the frictionless worst case. The catch is that opening further always means stretching the band: a long, narrow drawer that uses a back band gets a firm pull past about 90 mm (the console says where the band reaches 2.5×). The band has to span the full width, so wide drawers would need long bands that are barely stretched (a 180 mm wide drawer needs about 176 mm flat length).
  - *Kicker* (wide drawers): one short band on two posts that hang from the housing plate, one each side of the latch pocket. It is always a little stretched around them (1.2× with the drawer open), so it is never slack, and it never hooks onto the drawer, so there is nothing for it to fall off. Over the last `band_stroke` (32 mm) of closing, the back of the latch pocket pushes the middle of the band back into a V; released, the band pushes the drawer out again and lets go of it. Each post runs in a notch cut into the top of the drawer's back (about 8 mm deep), inside a small walled bay beside the pocket so nothing in the drawer sits in its way. The span is the same whatever the drawer's width.
    - Nothing catches the drawer once the band lets go; friction stops it. So the band is sized for the drawer, not just made strong: set `kicker_band_n` to the strength of the band you'll use (default 4 N, about a 1/8" wide band), and the console picks the ½" length (1.5"–6") that suits it for the drawer's estimated weight. The aim is that an empty drawer opens about twice the stroke. For example, a 200 × 150 × 40 mm drawer gets a 3.5" band on posts 97 mm apart: empty, it opens ~75 mm, and it still opens far enough to reset the latch with up to ~370 g inside.
    - The band always sits on its posts at the same 1.2× stretch, so a shorter band means posts closer together. The closed stretch is the same 32 mm stroke whatever the band, so on a shorter band it's a bigger share of its length: it stretches further (up to 2.5× at most) and stores more energy for the same strength. That's why the band and its post spacing get narrower as the drawer gets bigger. It isn't the width as such: a bigger drawer is heavier, has more friction to overcome, and needs more push from the same band. With the default 4 N band:

      | drawer (interior, mm) | rough weight | band | post spacing | stretched closed |
      |---|---|---|---|---|
      | 200 × 150 × 40 | 192 g | 3.5" | 97 mm | 1.5× |
      | 400 × 200 × 20 | 290 g | 3" | 82 mm | 1.6× |
      | 300 × 300 × 60 | 485 g | 2.5" | 67 mm | 1.8× |

    - To keep a wider span on a big drawer, use a stronger band and set `kicker_band_n` to match, for example 8 N for a 1/4" wide band, or a 1/8" band doubled. The console then picks a longer band on posts further apart that gives the same push. The span is also capped by the room beside the pocket: the posts stay inside the drawer's side walls and clear of the screw countersinks.
    - The console warns if your band could throw the empty drawer out, and says what strength it would rather have. Its numbers are rough (estimated weight, PLA-on-PLA friction 0.3), so try it before filling the drawer. A heavier load stops it shorter; if it stops before the latch resets, a short pull resets it.
    - The kicker needs the latch centred enough to leave room for a post on each side of the pocket (with `latch_side` left or right it usually falls back to the back band). On light drawers where only a very weak band (under 1.5 N) would suit the length that fits, the back band is used instead, since it also catches the drawer.
  - The kicker is used once a back band would need a flat length over 96 mm (from about 92 mm interior width), as long as it fits. The console says which one it picked and which band to buy.

## Hardware
- Countersunk wood screws: 4 for small drawers, more for long ones (the console prints the count; `screw_spacing` sets the most space allowed between screws along each side, default 100 mm, so a 200 mm deep drawer gets 6). #8 / 4 mm by default (pick #6, #8, #9 or #10 with `screw`). Length = desk thickness minus a few mm + 5 mm (the plate)
- Ejector: 1 rubber band: a large one (back band), or a short one for the kicker, its length picked for the drawer and `kicker_band_n`. The console says which, and the size
- 1 rubber band for the latch (size printed in the console; default: about 77 mm around / 39 mm flat, e.g. a #10 to #12 band, or a smaller one doubled)

## Print settings
- No part flexes, so PLA or PETG both work for all three parts.
- Print the arm with at least 3 perimeters so the pin is solid.

## Minimum sizes
The Customizer won't go below **47 mm wide, 62 mm deep, 17 mm tall** (interior). These are the smallest sizes that work with every screw size and the default latch and band settings. The width comes from the latch arm's swing, the depth from the arm and its band (spreader to back post), and the height from the drawer having to reach below the ejector band.

## Install
1. Screw the housing to the desk. All screws are reachable from below with the drawer out.
2. Stretch the latch band around the spreader (front of the pocket) and the post behind it, so it forms a long loop. Spread the strands apart and drop the arm's hub onto the pivot post between them; the band sits on either side of the arm's rounded tip. Nothing needs threading, so a doubled band is just as easy.
3. Back band: feed the ejector band through both loops on the drawer's back, slide the drawer in until its back is just short of the posts, and loop the band's ends over the posts from the sides. Kicker: stretch the band around both posts (between their flares) before you put the drawer in; it stays there, also when you take the drawer out. To take a back-band drawer out, slip the band off the posts.
4. Slide the drawer the rest of the way in. The funnel at the plate's front edge guides the pin into its groove.

## Tuning (Customizer)
- Slide too tight or too loose: `slide_clr`, `side_clr`.
- Arm sticks or wobbles on its pivot: `arm_clr`. Latch feels stiff or weak: use a looser or tighter latch band.
- Latch won't engage or release reliably: `pin_clr`. If you change the cam numbers, re-check them with `tools/camsim.ps1` (see below).
- Drawer stops short and needs a pull before it latches again: check `part = energy_map` for an uphill stretch. With a back band, keep `band_stroke` at least what the console asks for.
- Ejection too weak or too violent: change the band, or `band_stroke`. With the kicker, set `kicker_band_n` to your band's strength and use the length the console picks; `part = energy_map` estimates how far the empty drawer coasts.
- Latch pocket taking up too much room in a deep drawer: when the drawer is tall enough to leave at least `mech_slope_min` (default 10 mm) under it, the mechanism sits on a flat floor 2 mm below the arm, so the pivot post, the arm's tip support and the band posts stay short and stiff. That floor is the top of a solid wedge whose underside slopes 45° down to the back wall, so the space under it is open and it still prints without supports. The console says how much room it frees. Set `mech_slope_min` to 0 to use it whenever it fits, or 300 to keep walls down to the drawer floor.
- Back band wearing through: raise `back_r` (radius of the drawer's back corners where the band wraps, default 6 mm, max 12). Kicker drawers have square back corners, since their band never touches them.

## Debug stamp
Turn on `debug_stamp` (Output) to engrave each part, 0.5 mm deep, with the git commit it was made from and its part number: `1` housing (on its left outer side, and under the plate along its front edge, except on very narrow housings where it wouldn't be readable), `2` drawer (underneath), `3` arm (on top, between the hub and the pin). For example `2e161e2-2`. A `+` after the hash (`2e161e2+-2`) means the files had uncommitted changes. The console prints all three labels.

The hash is read from `version.scad`, which isn't committed (a file can't contain its own commit's hash). `tools/write_version.sh` writes it, and the hooks in `tools/githooks` rerun it after every commit, checkout, merge and rebase. Turn the hooks on once per clone:
```
git config core.hooksPath tools/githooks
sh tools/write_version.sh
```
The "uncommitted" flag is only as fresh as the last time the script ran, so rerun it before exporting if you've edited since your last commit. Without `version.scad` the stamp reads `nogit` and the console warns. From the command line you can also set the hash directly: `-D 'git_sha="abc1234"'`.

## Energy map
A drawer only runs by itself while the rubber bands' total stored energy keeps going down, because a band won't climb back up an energy hill. `part = energy_map` prints that total in the console (no geometry) through one cycle. It works each band's stretched length out from the real geometry: the latch band's two strands around the arm tip, and the back band from the posts to the loops, or the kicker's band from its posts round the back of the latch pocket. With the kicker it also estimates how far the empty drawer coasts after the band lets go, and how much it can carry and still reset. It lists:
- the latch band's and the ejector's energy at the key points (latched, released, the exit curve, the arm's furthest swing, the pin leaving the groove, the ejector relaxed);
- the two runs that have to happen on their own: released → open, and let go after the first push → into the notch. Each is either "downhill all the way", with the smallest net push left (in N) and the push as the pin leaves the groove, or a WARNING naming each uphill stretch, where the drawer stops unless momentum carries it.

Set `latch_band_n` and `ejector_band_n` (Energy map section; the kicker uses `kicker_band_n`) to your bands' strength: the pull in N it takes to stretch one to twice its length (100 g ≈ 1 N). It treats a band as a linear spring with no friction, so read the numbers as a comparison, not exact forces. For example, the old 25 mm stroke on the smallest drawer shows uphill from 25.5 to 28.6 mm out. The band was relaxed before the pin left the groove, which is why the drawer had to be pulled out the last bit before it would latch again.

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
