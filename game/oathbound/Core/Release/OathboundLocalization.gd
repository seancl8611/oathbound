extends RefCounted

## English-first localization bridge for launch. Stable IDs remain separate from English
## fallback copy so future Translation resources can replace text without changing save,
## achievement, narrative, Technique, Relic, or progression identifiers.


static func resolve(key: String, fallback: String) -> String:
	if key.is_empty():
		return fallback
	var translated: String = str(TranslationServer.translate(StringName(key)))
	if translated.is_empty() or translated == key:
		return fallback
	return translated


static func ui(key: String, fallback: String) -> String:
	return resolve("ui.%s" % key, fallback)


static func narrative_line(entry: Dictionary, line_index: int, fallback: String) -> String:
	var base_key: String = str(entry.get("loc_key", ""))
	if base_key.is_empty():
		return fallback
	return resolve("%s.line_%d" % [base_key, line_index + 1], fallback)


static func narrative_speaker(entry: Dictionary, fallback: String) -> String:
	var explicit_key: String = str(entry.get("speaker_loc_key", ""))
	if not explicit_key.is_empty():
		return resolve(explicit_key, fallback)
	var npc_id: String = str(entry.get("npc", ""))
	if not npc_id.is_empty():
		return resolve("npc.%s.name" % npc_id, fallback)
	var speaker_id: String = str(entry.get("speaker_id", ""))
	if not speaker_id.is_empty():
		return resolve("speaker.%s.name" % speaker_id, fallback)
	return fallback


static func catalog_name(category: String, stable_id: String, fallback: String) -> String:
	return resolve("catalog.%s.%s.name" % [category, stable_id], fallback)


static func catalog_details(category: String, stable_id: String, fallback: String) -> String:
	return resolve("catalog.%s.%s.details" % [category, stable_id], fallback)
