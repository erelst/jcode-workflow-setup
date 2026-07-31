# jcode-workflow-setup

**Strict Zero-Thinking Workflow** untuk jcode + Git.

Repository ini berisi aturan, script, skill, dan template untuk **strict zero-thinking workflow** jcode:

- Ontologi domain dulu + pahami *kenapa* kode lama ditulis begitu
- Larangan blind override / rewrite buta
- Characterization test dulu sebelum ubah kode
- Feature flag & Strangler Fig untuk migrasi/refactor
- **Tidak ada commit/push otomatis** — agent tawarkan opsi setelah test hijau
- Trivial: 2 opsi (commit langsung / review feedback)
- Non-trivial: 3 opsi (merge langsung / PR / review feedback)
- Loop review/feedback sampai user memutuskan
- Simpan memory setelah merge ke main untuk cegah regresi
- Branch management otomatis (deteksi `main` atau `master`)
- Swarm otomatis untuk tugas besar
- Auto-create test framework / CI / flag system jika belum ada

## Cara Pakai (Setup ke Proyek Target)

```bash
# Clone / extract repo ini
cd jcode-workflow-setup

# Jalankan setup ke proyek kamu
./setup.sh /path/ke/proyek-kamu

# Atau setup di direktori saat ini
./setup.sh .
```

Script `setup.sh` akan:

1. Menyalin `AGENTS.md` (hukum mutlak untuk agent)
2. Menyalin semua script di `scripts/` (termasuk deteksi main/master)
3. Menyiapkan skill `.jcode/skills/strict-workflow`
4. Menambahkan template CI GitHub Actions (jika belum ada)
5. Memberikan instruksi aktivasi hooks

## Setelah Setup

1. **Aktifkan hooks** di `~/.jcode/config.toml`:

   ```toml
   [hooks]
   before_commit = ["/path/ke/proyek/scripts/gate-green.sh"]
   after_turn    = ["/path/ke/proyek/scripts/auto-enforce.sh"]
   ```

2. (Opsional) Install GitHub CLI untuk membuat PR:
   ```bash
   brew install gh
   gh auth login
   ```

3. **Seed memory ke jcode** (wajib sekali setelah setup):
   ```
   jalankan scripts/seed-memory-prompt.md
   ```

4. Masuk ke proyek dan jalankan:
   ```bash
   cd /path/ke/proyek
   jcode
   ```

## Setup Opsional: CodeGraph & Ponytail

Tambahkan CodeGraph MCP dan Ponytail skill ke jcode secara opsional.
Paste prompt berikut ke chat jcode:

```
Setup CodeGraph dan Ponytail untuk jcode:
- CodeGraph: https://github.com/colbymchenry/codegraph
- Ponytail: https://github.com/DietrichGebert/ponytail
Baca kedua repo tersebut, lalu aktifkan CodeGraph MCP dan Ponytail skill
sesuai rekomendasi penggunaannya masing-masing.
```

Kegunaan:
- **CodeGraph** — knowledge graph kode (pre-indexed), eksplorasi struktur, call paths, impact analysis sebelum edit. Lebih sedikit tool calls.
- **Ponytail** — kode seminimal mungkin (YAGNI), review over-engineering, audit repo. Lebih sedikit kode, biaya, dan waktu.

## Penanganan main vs master

Semua script otomatis mendeteksi default branch:

1. Cek `origin/HEAD` (remote)
2. Jika tidak ada → cek branch lokal `main`, lalu `master`
3. Digunakan konsisten untuk checkout, pull, base PR, dan proteksi

Kamu tidak perlu khawatir apakah proyek memakai `main` atau `master`.

## Contoh Prompt (Zero Thinking)

Cukup bilang:

- `Migrasi authentication dari Express ke NestJS`
- `Refactor modul payment supaya scalable + rate limiting`
- `Tambah fitur export PDF di dashboard`
- `Perbaiki bug di endpoint /orders`

Agent akan otomatis menangani branch, test, flag, review loop, swarm, dll — tetapi commit/push/PR tetap butuh keputusan user.

## Isi Repository

```
jcode-workflow-setup/
├── AGENTS.md                 # Absolute rules (hukum agent)
├── setup.sh                  # Installer ke target project
├── README.md
├── scripts/
│   ├── lib.sh                # Helper deteksi main/master
│   ├── gate-green.sh         # Hanya boleh commit kalau hijau
│   ├── create-branch.sh      # Buat branch bersih dari default
│   ├── push.sh               # Push branch ke remote (tanpa auto-PR)
│   ├── create-pr.sh          # Buat PR setelah user approve
│   ├── merge-to-default.sh   # Merge langsung ke default branch
│   ├── auto-enforce.sh       # Enforce ringan setelah turn
│   ├── cleanup-branch.sh     # Hapus branch setelah merge
│   └── seed-memory-prompt.md # Prompt sekali jalan: seed aturan ke memory jcode
├── jcode/
│   ├── config-snippet.toml   # Contoh hooks
│   └── skills/
│       └── strict-workflow/
│           └── SKILL.md      # Skill yang di-inject otomatis
└── templates/
    └── github-actions-ci.yml # Minimal CI anti-regresi (main + master)
```

## Prinsip Desain

- **Incremental** (Strangler Fig + vertical slice)
- **Safety-first** (characterization → test hijau → loop feedback)
- **Local-first** (tidak ada commit/push otomatis, agent tawarkan opsi)
- **Memory protection** (simpan perubahan penting, beri peringatan jika tersentuh)
- **Otomatis** (agent memutuskan sendiri branch, swarm, flag, review loop, dll)
- **Zero reminder** (semua aturan ada di AGENTS.md + hooks)
- **Default-branch aware** (main atau master)

## Kustomisasi

Silakan edit `AGENTS.md` dan script sesuai stack & preferensi tim kamu.  
Setelah diubah, jalankan ulang `./setup.sh` ke proyek target.
