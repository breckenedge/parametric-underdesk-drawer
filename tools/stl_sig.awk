# Prints an ASCII STL's volume (mm³) and bounding box, rounded so float noise between two exports of
# the same part (vertices 0.01 mm apart, edges split differently) doesn't count as a difference.
/vertex/ { v[++k] = $2+0; v[++k] = $3+0; v[++k] = $4+0
  for (i = 0; i < 3; i++) { c = v[k-2+i]; if (n == 0 || c < mn[i]) mn[i] = c; if (n == 0 || c > mx[i]) mx[i] = c }
  n++
  if (k == 9) { vol += (v[1]*(v[5]*v[9]-v[6]*v[8]) - v[2]*(v[4]*v[9]-v[6]*v[7]) + v[3]*(v[4]*v[8]-v[5]*v[7])) / 6; k = 0 } }
END { printf "vol %.0f bbox %.1f %.1f %.1f\n", vol, mx[0]-mn[0], mx[1]-mn[1], mx[2]-mn[2] }
