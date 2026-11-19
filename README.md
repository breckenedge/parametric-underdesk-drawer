# Parametric Under-Desk Drawer (push-to-open)

An OpenSCAD drawer that screws under a desk and prints with no supports. Push the front to latch it; push again and a rubber band pops it open.

`underdesk_drawer.scad`: open it in OpenSCAD (nightly, with the Manifold backend). Set the size in the Customizer, then pick `part`.

`part = assembly` shows the drawer assembled in F5 preview; F6 renders all three parts laid out for printing (`print_layout` shows that layout in F5). The `assembly_open_pct` slider pulls the drawer out (100% leaves 15 mm in the housing). The pin stays in the groove on its way-out path, as after a release, and the latch arm swings to match.

`part = animation` animates one full latch cycle: latched → push → pops out to where the ejector leaves it → pushed back in → latched again. The pin follows the groove, the arm swings with it, and the rubber bands are drawn too (the back band follows the loops on the drawer's back). The housing is drawn as just its groove outline and band posts, so nothing hides the arm. `animation_drawer` can be `solid` or `ghost`. Press F5, then open the Animate panel: Window → Animate in recent OpenSCAD (View → Animate in 2021.01). Set FPS and Steps there, for example 15 and 100 (more Steps for deep drawers).

| part | print orientation | notes |
|---|---|---|
| `housing` | desk face down on the bed (already exported that way) | slide ledges, latch groove, screw holes, band posts |
| `drawer` | floor on the bed | lips, front panel, latch pocket with the arm's pivot post and band post |
| `arm` | flat on the bed, pin up | rigid latch arm that carries the pin |


## How it works
- **Slide:** 45° lips on the drawer rest on 45° ledges in the housing. This works like a dovetail. It centres the drawer side to side, and both parts print with no overhang steeper than 45°. If the print comes out a little wider or narrower, the drawer just rides slightly higher or lower.
- **Latch:** a push-push "heart cam" groove is cut into the housing plate. The pin that runs in it sits on a rigid arm in a pocket at the back centre of the drawer. The arm swings sideways on a post at its front end, so the cam can push it sideways without it tipping or jamming, and the push of the latch goes straight along the arm into the post. One rubber band is stretched lengthwise around a spreader in front of the arm's hub and a post behind its tip, with the arm sitting between its two strands. When the arm swings, its rounded tip pushes one strand out like a bowstring, and the band pulls it back to centre. At rest both strands press lightly on the tip, so there's no dead zone in the middle. No printed part has to flex. The pin moves on a slight arc, so the groove is drawn with that correction. `latch_side` puts the groove and the drawer's mechanism pocket in the centre (default), or as far to the left or right as fits (seen from the front), which leaves one wide open area in the drawer instead of two narrow ones. Centred, the latch pulls straight and doesn't twist the drawer on the slide; off to one side it pulls slightly at an angle, which the dovetail slide holds. `latch_y` adds a fine sideways shift in mm (+ = left). A gap narrower than 12 mm between the pocket and a side wall is closed off, so there's no dust slot. The cycle is: push in → latch (the drawer sits about 7.5 mm proud) → push about 5 mm or more → release. On the way out after release, the groove steers the pin back across on a smooth S-curve (no corners, at most about 36° off straight) rather than a sharp 45° bend, so the drawer doesn't stutter there. That swing stretches the latch band, so the curve does most of it early, while the ejector still pushes hard, and the last stretch to the groove's mouth lets the latch band push the drawer out instead.
- **Ejector:** two layouts, picked automatically:
  - *Back band* (small drawers): one rubber band loops around two posts that hang under the housing walls. Closing the drawer makes its back wall stretch the band. The band is fed through two loops on the drawer's back (short rounded tunnels, flat against the wall and curved top and bottom; where a curve would overhang it runs at 45° instead, with a short flat at the top of the tunnel, so they print without supports), so it stays with the drawer and also stops it: once the drawer's back passes the posts, the band stretches the other way and pulls it back. Released, the drawer settles about `band_stroke` (32 mm) open, and even a strong band can't throw it out further than about twice that, because the band can only give back the energy it stored when the drawer closed. On short drawers the stroke is cut so that stays 15 mm inside the housing, but never below about 31 mm. The band has to still be pushing when the latch pin leaves its groove, about 26 mm out; otherwise the drawer stops with the pin still on its way out and needs a pull before it latches again. On the shortest drawers that leaves only 4 mm on the ledges in the frictionless worst case. The catch is that opening further always means stretching the band: a long, narrow drawer that uses a back band gets a firm pull past about 90 mm (the console says where the band reaches 2.5×). The band has to span the full width, so wide drawers need long bands (a 180 mm wide drawer needs about 176 mm flat length).
  - *Side bands* (wide drawers): one band per side, looped around a post under the housing wall and a hook on the drawer's side wall near the back. The hook is a short arm sticking straight out of the side wall with a lip at its end, like a coat hook; the band loops over the arm and sits against the lip. Its underside rises 45° from the wall, so it prints without supports. It sits lower than the post so it passes under it when the drawer goes in or out (the band twists a quarter turn between them, which is fine). Released, the drawer runs out until only the latch pocket is still in the housing, and no band, however strong, can throw it out:
    - A band between a fixed post and a moving hook pulls the same whether the hook is behind the post or in front of it. Released, the bands push the drawer for a short stroke, go slack while the hook passes under the post, then stretch the other way. With no friction the drawer would swing out to the mirror image of where it started: the end of the slack stretch plus the stroke, however strong the band.
    - So the slack stretch is made to end just before the latch pocket would leave the housing (everything else is out by then). The stroke is at least about 31 mm, so the bands are still pushing when the latch pin leaves its groove and the drawer resets by itself. It's also short enough that the overshoot still leaves 15 mm of the drawer in the housing.
    - Which band does that depends on the drawer's depth, so the console picks the size: the shortest ½" length that fits, for the most push. For example 1.5" at 146–160 mm interior depth, 2.5" at 200, 3.5" at 250, 4" at 300, 6" at 400. On deep drawers the stroke limits leave no ½" size that ends the slack stretch exactly there, so it ends a few mm short (the console says how much).
    - Where the drawer stops within the slack stretch depends on friction. If it stops short, use stiffer bands of the same length (thicker, or two together). That opens it further without letting it fly out.
    - Deep drawers use long bands that are only stretched a little when closed (about 1.3× at 300 mm), so they need stiffer bands to push hard. The bands stay on the drawer, so pulling it further than the overshoot point meets a firm pull back. Slip them off the hooks to take the drawer out.
    - They need at least 146 mm interior depth and 26 mm interior height. Shallower than that, a side band can't open the drawer to the latch pocket without being able to throw it out, so the back band is used instead.
  - Side bands are used once a back band would need a flat length over 96 mm (from about 92 mm interior width), as long as the drawer is deep and tall enough. The console says which one it picked and which bands to buy.

## Hardware
- Countersunk wood screws: 4 for small drawers, more for long ones (the console prints the count; `screw_spacing` sets the most space allowed between screws along each side, default 100 mm, so a 200 mm deep drawer gets 6). #8 / 4 mm by default (pick #6, #8, #9 or #10 with `screw`). Length = desk thickness minus a few mm + 5 mm (the plate)
- Ejector: 1 large rubber band (back band) or 2 bands per side-band drawer, their length picked for the drawer's depth. The console says which, and the size
- 1 rubber band for the latch (size printed in the console; default: about 77 mm around / 39 mm flat, e.g. a #10 to #12 band, or a smaller one doubled)

## Print settings
- No part flexes, so PLA or PETG both work for all three parts.
- Print the arm with at least 3 perimeters so the pin is solid.

## Minimum sizes
The Customizer won't go below **47 mm wide, 62 mm deep, 17 mm tall** (interior). These are the smallest sizes that work with every screw size and the default latch and band settings. The width comes from the latch arm's swing, the depth from the arm and its band (spreader to back post), and the height from the drawer having to reach below the ejector band.

## Install
1. Screw the housing to the desk. All screws are reachable from below with the drawer out.
2. Stretch the latch band around the spreader (front of the pocket) and the post behind it, so it forms a long loop. Spread the strands apart and drop the arm's hub onto the pivot post between them; the band sits on either side of the arm's rounded tip. Nothing needs threading, so a doubled band is just as easy.
3. Back band: feed the ejector band through both loops on the drawer's back, slide the drawer in until its back is just short of the posts, and loop the band's ends over the posts from the sides. Side bands: loop one band around each post now, and hook the other end over the drawer's hook once the drawer is in (over the lip, so it sits on the arm against the lip). To take the drawer out, slip the band(s) off the posts or hooks.
4. Slide the drawer the rest of the way in. The funnel at the plate's front edge guides the pin into its groove.

## Tuning (Customizer)
- Slide too tight or too loose: `slide_clr`, `side_clr`.
- Arm sticks or wobbles on its pivot: `arm_clr`. Latch feels stiff or weak: use a looser or tighter latch band.
- Latch won't engage or release reliably: `pin_clr`. If you change the cam numbers, re-check them with `tools/camsim.ps1` (see below).
- Drawer stops short and needs a pull before it latches again: check `part = energy_map` for an uphill stretch. With a back band, keep `band_stroke` at least what the console asks for.
- Ejection too weak or too violent: change the band, or (back band) `band_stroke`. With side bands, use a stiffer band of the same length or a doubled pair; their stroke is set by the drawer so they can never throw it out.
- Latch pocket taking up too much room in a deep drawer: when the drawer is tall enough to leave at least `mech_slope_min` (default 10 mm) under it, the mechanism sits on a flat floor 2 mm below the arm, so the pivot post, the arm's tip support and the band posts stay short and stiff. That floor is the top of a solid wedge whose underside slopes 45° down to the back wall, so the space under it is open and it still prints without supports. The console says how much room it frees. Set `mech_slope_min` to 0 to use it whenever it fits, or 300 to keep walls down to the drawer floor.
- Ejector band wearing through: raise `back_r` (radius of the drawer's back corners where the band wraps, default 6 mm, max 12).

## Debug stamp
Turn on `debug_stamp` (Output) to engrave each part, 0.5 mm deep, with the git commit it was made from and its part number: `1` housing (on its left outer side, and under the plate along its front edge, except on very narrow housings where it wouldn't be readable), `2` drawer (underneath), `3` arm (on top, between the hub and the pin). For example `2e161e2-2`. A `+` after the hash (`2e161e2+-2`) means the files had uncommitted changes. The console prints all three labels.

The hash is read from `version.scad`, which isn't committed (a file can't contain its own commit's hash). `tools/write_version.sh` writes it, and the hooks in `tools/githooks` rerun it after every commit, checkout, merge and rebase. Turn the hooks on once per clone:
```
git config core.hooksPath tools/githooks
sh tools/write_version.sh
```
The "uncommitted" flag is only as fresh as the last time the script ran, so rerun it before exporting if you've edited since your last commit. Without `version.scad` the stamp reads `nogit` and the console warns. From the command line you can also set the hash directly: `-D 'git_sha="abc1234"'`.

## Energy map
A drawer only runs by itself while the rubber bands' total stored energy keeps going down, because a band won't climb back up an energy hill. `part = energy_map` prints that total in the console (no geometry) through one cycle. It works each band's stretched length out from the real geometry: the latch band's two strands around the arm tip, and the back band from the posts to the loops or each side band from post to hook. It lists:
- the latch band's and the ejector's energy at the key points (latched, released, the exit curve, the arm's furthest swing, the pin leaving the groove, the ejector relaxed);
- the two runs that have to happen on their own: released → open, and let go after the first push → into the notch. Each is either "downhill all the way", with the smallest net push left (in N) and the push as the pin leaves the groove, or a WARNING naming each uphill stretch, where the drawer stops unless momentum carries it.

Set `latch_band_n` and `ejector_band_n` (Energy map section) to your bands' strength: the pull in N it takes to stretch one to twice its length (100 g ≈ 1 N). It treats a band as a linear spring with no friction, so read the numbers as a comparison, not exact forces. For example, the old 25 mm stroke on the smallest drawer shows uphill from 25.5 to 28.6 mm out. The band was relaxed before the pin left the groove, which is why the drawer had to be pulled out the last bit before it would latch again.

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
- `tools/cammargin.ps1` checks the one thing the slow-motion simulation can't: momentum. On the way out after the first push, the band pulls the pin toward the exit side. A fast-swinging arm, a drawer that bounces, or play in the pivot can carry it over the catch, especially when the unit isn't level, because then nothing presses the arm onto its post to damp it. The tool finds the smallest amount the drawer would have to move back in, part-way through that return, for the pin to skip the catch: **2.1 mm** (the earlier groove had 0.66 mm). The return path drops straight for a while before turning toward the notch, and the exit ramp climbs higher.
  ```
  powershell -ExecutionPolicy Bypass -File tools\cammargin.ps1 -dump dump.echo
  ```

**Not yet physically tested.** Expect to tune clearances on the first print.
