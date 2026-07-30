# Seed Memory Prompt – Strict Workflow Rules (v2)
# Jalankan sekali di jcode setelah setup:
#   1. Copy-paste blok di bawah ke chat jcode
#   2. Jcode akan membaca AGENTS.md dan menyimpan memory

---

Baca file AGENTS.md di root project ini secara lengkap.

Simpan sebagai persistent memory (project-scoped) dengan struktur berikut:

## PROTECTED: STRICT WORKFLOW RULES – jcode-workflow-setup

### Aturan inti yang harus diingat:

1. **Question user input first** — Jangan eksekusi prompt mentah-mentah. Selalu pertanyakan: apakah ini benar atau kesalahpahaman?

2. **No auto commit/push** — Trivial: 2 opsi (commit langsung / review). Non-trivial: 3 opsi (merge langsung / PR / review). Tunggu user.

3. **Loop review/feedback** — Jika user pilih review/feedback, tampilkan terus opsi sampai user pilih merge/commit.

4. **Memory protection** — Setiap merge ke main: simpan (files, what/why, risk areas, trade-offs, tags). Sebelum edit file: cek memory protected area.

5. **Ontologi + alasan kode lama** dulu sebelum edit.

6. **Larangan blind override** — Path baru dulu (adapter/flag), baru hapus yang lama.

7. **Feature flag wajib** untuk fitur baru (default OFF).

### Tags untuk context recall (jangan hardcode, gunakan konteks):
- Semua aturan di atas → "workflow", "agents.md", "strict-workflow"
- Memory protection → "no-blind-override", "protected-area", "risk-area", "regression-protection"
- Ontologi → "ontology", "domain-understanding", "why-existing-code"
- No auto commit → "local-first", "no-auto-commit", "offer-options", "user-approval"
- Review loop → "review-feedback-loop", "feedback-loop"
- Feature flag → "feature-flag", "strangler-fig", "adapter"

### Prompt context-trigger (untuk auto-recall):

Setiap kali akan mengerjakan task:
1. Panggil `memory recall` dengan query yang relevan: nama file, nama fungsi, konsep domain, pola arsitektur.
   Contoh: `memory recall auth login flow` atau `memory recall file src/services/payment.ts`
2. Jika hasil recall berisi `## PROTECTED:` → tampilkan ke user + konfirmasi sebelum lanjut.

Setelah merge/commit ke main:
1. Panggil `memory remember` dengan format:
   ```
   ## PROTECTED: <judul>
   - Files: <path>
   - What: <ringkasan>
   - Rationale: <kenapa>
   - Risk areas: <fragile parts>
   - Trade-offs: <dikorbankan>
   - Tags: <context keywords>
   ```
2. Scope: project. Tags: path file, nama fungsi, konsep domain.

Ingat: tags harus granular (path file, function names, konsep spesifik) agar recall berdasarkan konteks alami bekerja — bukan hardcode keyword buatan.

Konfirmasi setelah semua memory tersimpan.
