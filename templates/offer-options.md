# Template Menawarkan Opsi (trivial & non-trivial)

Gunakan format ini setiap kali menawarkan opsi selanjutnya ke user,
setelah test lokal hijau. Berlaku untuk trivial (2 opsi) maupun non-trivial (3 opsi).

---

## Verifikasi

- [ ] Test lokal hijau
- [ ] <verifikasi lain yang sudah dilalui>

## Perubahan yang dilakukan (berdasarkan permintaan)

- <file> — <apa yang diubah + kenapa>
- <file> — <apa yang diubah + kenapa>

## Status branch <nama-branch> (<N> commit)

- <hash7> <oneline commit>
- <hash7> <oneline commit>

## Opsi selanjutnya

- **A** — <opsi A>
- **B** — <opsi B>
- **C** — <opsi C>   (hanya non-trivial)

**Pilih mana?**

---

### Catatan

- **Non-trivial**: Opsi A = merge langsung ke main, Opsi B = buat PR, Opsi C = review/feedback (loop sampai user pilih A atau B).
- **Trivial**: Opsi A = commit langsung, Opsi B = review/feedback (loop sampai user pilih A).
- Bagian "Perubahan yang dilakukan" WAJIB diisi agar user tahu persis apa yang akan di-commit/merge.
