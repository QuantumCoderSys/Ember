#ifndef EMBER_CORE_H
#define EMBER_CORE_H

#ifdef __cplusplus
extern "C" {
#endif

/* Owned UTF-8 JSON. Returns NULL on failure. Free with ember_core_string_free. */
char *ember_core_snapshot_json(void);
/* Accepts NULL. Non-null pointers must originate above and be freed only once. */
void ember_core_string_free(char *value);

#ifdef __cplusplus
}
#endif
#endif
