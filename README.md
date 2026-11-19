# Parametric Under-Desk Drawer (push-to-open)

An OpenSCAD drawer that screws under a desk and prints with no supports. Push the front to latch it; push again and a rubber band pops it open.

`underdesk_drawer.scad`: open it in OpenSCAD (nightly, with the Manifold backend). Set the size in the Customizer, then pick `part`.

`part = assembly` shows the drawer assembled in F5 preview; F6 renders all three parts laid out for printing (`print_layout` shows that layout in F5).

| part | print orientation | notes |
|---|---|---|
| `housing` | desk face down on the bed (already exported that way) | slide ledges, latch groove, screw holes, band posts |
| `drawer` | floor on the bed | lips, front panel, latch pocket with the arm's pivot post and band post |
| `arm` | flat on the bed, pin up | rigid latch arm that carries the pin |


## How it works
- **Slide:** 45° lips on the drawer rest on 45° ledges in the housing. This works like a dovetail. It centres the drawer side to side, and both parts print with no overhang steeper than 45°. If the print comes out a little wider or narrower, the drawer just rides slightly higher or lower.
- **Latch:** a push-push "heart cam" groove is cut into the housing plate. The pin that runs in it sits on a rigid arm in a pocket at the back centre of the drawer. The arm swings sideways on a post at its front end, so the cam can push it sideways without it tipping or jamming, and the push of the latch goes straight along the arm into the post. One rubber band is stretched lengthwise around a spreader in front of the arm's hub and a post behind its tip, with the arm sitting between its two strands. When the arm swings, its rounded tip pushes one strand out like a bowstring, and the band pulls it back to centre. At rest both strands press lightly on the tip, so there's no dead zone in the middle. No printed part has to flex. The pin moves on a slight arc, so the groove is drawn with that correction. Centred, the latch pulls straight and doesn't twist the drawer on the slide; `latch_y` shifts it sideways if you need the space. The cycle is: push in → latch (the drawer sits about 7.5 mm proud) → push about 5 mm or more → release.
- **Ejector:** one rubber band loops around two posts that hang under the housing walls. Closing the drawer makes its back wall stretch the band. The OpenSCAD console prints the band size to buy (default test size: about 60 mm flat length; a 180 × 200 mm drawer needs about 176 mm, e.g. a 7" #117B).

## Hardware
- Countersunk wood screws: 4 for small drawers, more for long ones (the console prints the count; `screw_spacing` sets the most space allowed between screws along each side, default 100 mm, so a 200 mm deep drawer gets 6). #8 / 4 mm by default (pick #6, #8, #9 or #10 with `screw`). Length = desk thickness minus a few mm + 5 mm (the plate)
- 1 large rubber band for the ejector (size printed in the console)
- 1 rubber band for the latch (size printed in the console; default: about 77 mm around / 39 mm flat, e.g. a #10 to #12 band, or a smaller one doubled)

## Print settings
- No part flexes, so PLA or PETG both work for all three parts.
- Print the arm with at least 3 perimeters so the pin is solid.

## Minimum sizes
The Customizer won't go below **47 mm wide, 62 mm deep, 17 mm tall** (interior). These are the smallest sizes that work with every screw size and the default latch and band settings. The width comes from the latch arm's swing, the depth from the arm and its band (spreader to back post), and the height from the drawer having to reach below the ejector band.

## Install
1. Screw the housing to the desk. All screws are reachable from below with the drawer out.
2. Loop the ejector band around both posts.
3. Stretch the latch band around the spreader (front of the pocket) and the post behind it, so it forms a long loop. Spread the strands apart and drop the arm's hub onto the pivot post between them; the band sits on either side of the arm's rounded tip. Nothing needs threading, so a doubled band is just as easy.
4. Slide the drawer in. The funnel at the plate's front edge guides the pin into its groove.

## Tuning (Customizer)
- Slide too tight or too loose: `slide_clr`, `side_clr`.
- Arm sticks or wobbles on its pivot: `arm_clr`. Latch feels stiff or weak: use a looser or tighter latch band.
- Latch won't engage or release reliably: `pin_clr`. If you change the cam numbers, re-check them with `tools/camsim.ps1` (see below).
- Ejection too weak or too violent: change the band, or change `band_stroke`.
- Latch pocket taking up too much room in a deep drawer: when the drawer is tall enough to leave at least `mech_slope_min` (default 10 mm) under it, the mechanism sits on a flat floor 2 mm below the arm, so the pivot post, the arm's tip support and the band posts stay short and stiff. That floor is the top of a solid wedge whose underside slopes 45° down to the back wall, so the space under it is open and it still prints without supports. The console says how much room it frees. Set `mech_slope_min` to 0 to use it whenever it fits, or 300 to keep walls down to the drawer floor.
- Ejector band wearing through: raise `back_r` (radius of the drawer's back corners where the band wraps, default 6 mm, max 12).

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
- `tools/cammargin.ps1` checks the one thing the slow-motion simulation can't: momentum. On the way out after the first push, the band pulls the pin toward the exit side. A fast-swinging arm, a drawer that bounces, or play in the pivot can carry it over the catch, especially when the unit isn't level, because then nothing presses the arm onto its post to damp it. The tool finds the smallest amount the drawer would have to move back in, part-way through that return, for the pin to skip the catch: **1.6 mm** (the earlier groove had 0.66 mm). The return path drops straight for a while before turning toward the notch, and the exit ramp climbs higher.
  ```
  powershell -ExecutionPolicy Bypass -File tools\cammargin.ps1 -dump dump.echo
  ```

**Not yet physically tested.** Expect to tune clearances on the first print.
