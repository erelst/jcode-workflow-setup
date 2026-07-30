# Strict Workflow Skill

Gunakan skill ini otomatis ketika mendeteksi tugas migrasi framework, refactor besar, atau penambahan fitur baru.

## Langkah wajib (ikuti berurutan)

1. **Ontologi & alasan kode lama**
   - Identifikasi konsep domain, entity, relasi, invariant.
   - Baca kode target + konteks; jelaskan *kenapa* ditulis seperti itu sebelum edit.
   - Dilarang blind override / rewrite buta.

2. **Memory Protection Check**
   - Sebelum edit, cek memory jcode apakah file/fungsi/konsep yang disentuh ada di area proteksi.
   - Jika ada, konfirmasi ke user.

3. **Branch**
   - Deteksi default branch (main atau master).
   - Buat branch baru dari default branch terbaru dengan naming `type/deskripsi-singkat`.

4. **Characterization / Safety Net**
   - Jika belum ada test relevan → buat characterization test yang merekam perilaku saat ini.
   - Pastikan test hijau sebelum mengubah production code.

5. **Feature Flag / Adapter (jika applicable)**
   - Migrasi → buat adapter + feature flag (default OFF).
   - Fitur baru → bungkus di feature flag (default OFF).
   - Jangan langsung override path lama.

6. **Implementasi incremental**
   - Kerjakan per vertical slice kecil.
   - Setelah setiap slice: jalankan test → perbaiki sampai hijau.

7. **Local First — Tawarkan opsi setelah test hijau**
   - TIDAK ADA commit/push otomatis.
   - **Non-trivial**: setelah test lokal hijau, tawarkan 3 opsi:
     * **Opsi A — Merge langsung**: via `merge-to-default.sh`. Tanya user untuk push.
     * **Opsi B — PR**: push → wait CI → create PR.
     * **Opsi C — Review/feedback**: terima input user → analisa → edit → test → ulangi 3 opsi. Loop.
   - **Trivial**: setelah test lokal hijau, tawarkan 2 opsi:
     * **Opsi A — Commit langsung** ke default branch, push.
     * **Opsi B — Review/feedback**: terima input → edit → test → ulangi 2 opsi. Loop.

8. **Simpan Memory**
   - Setelah merge ke main (via jalur apapun), simpan perubahan ke persistent memory.
   - Format: files changed, what/why, risk areas, trade-offs, tags untuk context recall.

9. **Cleanup**
   - Hapus feature branch (lokal + remote).
   - Kembali ke default branch dan pull.

## Confidence
Selalu update todo + confidence score. Jangan claim selesai di bawah 90.
