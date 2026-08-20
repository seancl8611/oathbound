extends "res://Enemy/Area 2/Encounter/lantern_wraith.gd"

## Legacy compatibility shim.
##
## lantern_wraith.tscn from the imported prototype still points at the old
## `res://Enemy/Area 2/archer_v2.gd` path, while the actual migrated implementation
## lives in `Encounter/lantern_wraith.gd`. Keep the old path resolvable during the
## engine migration; the later Yomori reconciliation can remove this alias when the
## scene is rewritten against current authority.
