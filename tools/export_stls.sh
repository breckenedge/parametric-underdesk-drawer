#!/bin/sh
# Export the STLs for every Customizer preset in underdesk_drawer.json into stl/.
#   stl/<preset>/housing.stl, drawer.stl   – these change with the drawer's size
#   stl/common/cassette.stl, arm.stl       – the same for every drawer, so exported once
# If a preset's cassette or arm differs from the common one (another cassette_mount, cassette_bolt,
# mortise_clr, arm_clr ...), it goes in that preset's folder instead.
# "Differs" means another volume or bounding box (tools/stl_sig.awk), not other bytes: the same part
# exported for two drawers comes out with its vertices up to 0.01 mm apart.
# Folders are named by the overall size actually built (a preset below the minimum is raised).
# Refuses to run with uncommitted changes to the model, so every STL comes from a commit.
# Usage: sh tools/export_stls.sh        (from the repo root; needs git and OpenSCAD)
set -e
cd "$(dirname "$0")/.."
OS=${OPENSCAD:-"/c/Program Files/OpenSCAD/openscad.com"}
[ -x "$OS" ] || OS=openscad
if ! git diff --quiet HEAD -- underdesk_drawer.scad underdesk_drawer.json; then
  echo "underdesk_drawer.scad/.json have uncommitted changes – commit them first" >&2; exit 1
fi
rev=$(git log -1 --format=%h -- underdesk_drawer.scad underdesk_drawer.json)
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
# the presets each save a "part"; a preset beats -D, so drop it (the JSON's last-entry commas are
# never on "part", which sorts before the parameters that follow it)
grep -v '"part":' underdesk_drawer.json > "$tmp/presets.json"
rm -rf stl/common stl/set-*
mkdir -p stl/common

grep -o '"New set [0-9]*"' underdesk_drawer.json | tr -d '"' | while IFS= read -r p; do
  n=${p##* }
  run() { "$OS" -o "$2" -p "$tmp/presets.json" -P "$p" -D "part=\"$1\"" underdesk_drawer.scad > "$tmp/$n-$1.log" 2>&1; }
  run housing "$tmp/$n-housing.stl"
  # overall size as built: the preset's outer_w/d/h, or the "below the minimum – using N mm" the
  # model reported instead
  vals=$(sed -n "/\"$p\"/,/}/p" underdesk_drawer.json)
  size=""
  for k in outer_w outer_d outer_h; do
    v=$(sed -n "s/.*WARNING: $k = .* using \([0-9.]*\) mm.*/\1/p" "$tmp/$n-housing.log")
    [ -n "$v" ] || v=$(echo "$vals" | sed -n "s/.*\"$k\": \"\([0-9.]*\)\".*/\1/p" | awk '{printf "%g", $1}')
    size="$size${size:+x}$v"
  done
  d="stl/set-${n}_$size"
  mkdir -p "$d"
  mv "$tmp/$n-housing.stl" "$d/housing.stl"
  run drawer "$d/drawer.stl"
  for part in cassette arm; do
    run $part "$tmp/$n-$part.stl"
    if [ ! -f stl/common/$part.stl ]; then cp "$tmp/$n-$part.stl" stl/common/$part.stl
    elif [ "$(awk -f tools/stl_sig.awk "$tmp/$n-$part.stl")" != "$(awk -f tools/stl_sig.awk stl/common/$part.stl)" ]; then cp "$tmp/$n-$part.stl" "$d/$part.stl"; fi
  done
  { echo "Preset: $p    model commit: $rev"
    echo
    grep '^ECHO' "$tmp/$n-housing.log" | sed 's/^ECHO: "\(.*\)"$/\1/'
    echo
    for part in cassette arm; do
      if [ -f "$d/$part.stl" ]; then echo "$part: this folder (differs from stl/common)"
      else echo "$part: stl/common/$part.stl"; fi
    done
  } > "$d/notes.txt"
  echo "$d done"
done
echo "Cassette and arm, the same for every preset unless that preset's folder has its own. Model commit: $rev" > stl/common/notes.txt
