# Strict Workflow Skill

Gunakan skill ini otomatis ketika mendeteksi tugas migrasi framework, refactor besar, atau penambahan fitur baru.

## Langkah wajib (ikuti berurutan)

1. **Ontologi & alasan kode lama**
   - Identifikasi konsep domain, entity, relasi, invariant.
   - Baca kode target + konteks; jelaskan *kenapa* ditulis seperti itu sebelum edit.
   - Dilarang blind override / rewrite buta.

2. **Branch**
   - Deteksi default branch (main atau master).
   - Buat branch baru dari default branch terbaru dengan naming `type/deskripsi-singkat`.

3. **Characterization / Safety Net**
   - Jika belum ada test yang relevan → buat characterization test yang merekam perilaku saat ini.
   - Pastikan test hijau sebelum mengubah production code.

4. **Feature Flag / Adapter (jika applicable)**
   - Migrasi → buat adapter + feature flag (default OFF).
   - Fitur baru → bungkus di feature flag (default OFF).
   - Jangan langsung override path lama.

5. **Implementasi incremental**
   - Kerjakan per vertical slice kecil.
   - Setelah setiap slice: jalankan test → perbaiki sampai hijau.

6. **Commit, Push, then CI → offer options**
   - Hanya commit jika test hijau.
   - Gunakan conventional commits.
   - Push branch ke remote (tanpa auto-PR).
   - Tunggu CI hijau.
   - Tawarkan 2 opsi ke user:
     * **Opsi A — PR**: jika user setuju, buat PR via `scripts/create-pr.sh`.
     * **Opsi B — Merge langsung**: jika user pilih, merge via `scripts/merge-to-default.sh`.

7. **Cleanup**
   - Setelah merge & stabil → hapus kode lama + flag (jika sudah tidak dipakai).
   - Hapus feature branch (lokal + remote).

## Confidence
Selalu update todo + confidence score. Jangan claim selesai di bawah 90.
