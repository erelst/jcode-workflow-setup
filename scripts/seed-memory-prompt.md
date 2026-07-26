# Seed Memory Prompt – Strict Workflow Rules
# Jalankan sekali di jcode setelah setup (copy-paste seluruh blok di bawah ke chat jcode)

---

Baca file AGENTS.md di root project ini secara lengkap.

Simpan sebagai persistent memory (project-scoped) dengan ringkasan yang sangat kuat dan mudah di-recall, fokus pada aturan ABSOLUT berikut:

1. Ontologi domain dulu + jelaskan kenapa kode lama ditulis begitu sebelum edit apapun.
2. LARANGAN blind override / rewrite buta. Ganti fundamental hanya lewat adapter + feature flag.
3. Characterization test dulu jika belum ada; hanya commit kalau test 100% hijau.
4. Migrasi = Strangler Fig + adapter + feature flag (default OFF).
5. Fitur baru = wajib di balik feature flag (default OFF).
6. Selalu kerja di feature branch (deteksi main ATAU master otomatis). Jangan commit ke default branch.
7. Tugas besar → otomatis swarm (implement + test + review).
8. Auto-create yang belum ada: test framework, feature flag system, CI minimal.

Format memory:
- Judul jelas: "STRICT WORKFLOW RULES – jcode-workflow-setup"
- Poin-poin pendek, tegas, actionable
- Tag/keyword: workflow, agents.md, no-blind-override, ontology, characterization, feature-flag, strangler, branch, swarm, green-only-commit

Konfirmasi setelah memory tersimpan dan sebutkan ringkasan yang disimpan.
Lalu aktifkan / pastikan memory feature ON.
