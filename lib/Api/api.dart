class Api {
  static token() {
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoxLCJuYW1hIjoicm9vdCIsImVtYWlsIjoicm9vdEBsb2NhbGhvc3QifSwiaWF0IjoxNTkyMjM1MzE2fQ.KHYQ0M1vcLGSjJZF-zvTM5V44hM0B8TqlTD0Uwdh9rY';
  }

  static infoId(id) {
    return 'http://suhu.local.sipatex.co.id:3002/sptx_attd/info-id/$id';
  }

  static lastId(id) {
    return 'http://suhu.local.sipatex.co.id:3002/sptx_attd/last-id/$id';
  }

  static absen(kartu, terminal) {
    return 'http://suhu.local.sipatex.co.id:3002/sptx_attd/?kartu_id=$kartu&terminaz=$terminal&statuz=IN';
  }

  static absenKeluar(kartu, terminal) {
    return 'http://suhu.local.sipatex.co.id:3002/sptx_attd/?kartu_id=$kartu&terminaz=$terminal&statuz=out';
  }
}
