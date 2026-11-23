#!/usr/bin/env bash
# SessionStart hook: print the handoff and the roadmap's "Now" section so a fresh session can orient.
root="$(cd "$(dirname "$0")/.." && pwd)"
echo "=== docs/HANDOFF.md ==="
if [ -f "$root/docs/HANDOFF.md" ]; then cat "$root/docs/HANDOFF.md"; else echo "(no handoff yet)"; fi
echo
echo "=== docs/ROADMAP.md (header + Now) ==="
if [ -f "$root/docs/ROADMAP.md" ]; then
  awk '/^## Next/{exit} {print}' "$root/docs/ROADMAP.md"
fi
echo
echo "=== git ==="
git -C "$root" branch --show-current 2>/dev/null
git -C "$root" log --oneline -3 2>/dev/null
git -C "$root" status --short 2>/dev/null | head -15
exit 0
