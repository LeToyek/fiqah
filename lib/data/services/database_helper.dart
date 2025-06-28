import 'package:fiqah/data/models/content_model.dart';
import 'package:fiqah/data/models/menu_category_model.dart';
import 'package:fiqah/data/models/sub_menu_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path =
        join(await getDatabasesPath(), 'fiqah_app_v3.db'); // v3 for new schema
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        iconCodePoint INTEGER NOT NULL,
        startColor INTEGER NOT NULL,
        endColor INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE sub_menus(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL UNIQUE,
        categoryId INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE contents(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subMenuTitle TEXT NOT NULL UNIQUE,
        content TEXT NOT NULL,
        reference TEXT,
        FOREIGN KEY (subMenuTitle) REFERENCES sub_menus(title) ON DELETE CASCADE
      )
    ''');

    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {
    final List<Map<String, dynamic>> initialData = [
      {
        'title': 'Pra Nikah',
        'icon': Icons.psychology,
        'gradient': [Colors.pink[300]!, Colors.pink[500]!],
        'subMenus': [
          {
            'title': 'Pengertian & Tujuan Pernikahan',
            'content': '''
Pernikahan (nikah) dalam islam adalah sebuah perjanjian suci antara laki laki dan perempuan untuk membangun kehidupan Bersama sebagai suami istri. Perjanjian ini menjadi jalan yang halal untuk saling mencintai, menunaikan hak dan kewajiban serta membentuk keluarga yang diberkahi.

### Tujuan Pernikahan dalam Islam
Islam tidak hanya memandang pernikahan dari aspek biologis semata, tapi juga dari sisi psikologis, spiritual dan sosial. Tujuannya antara lain:

* **Menjaga kesucian dan harga diri.** Untuk menghindari zina dan menjaga kehormatan.
* **Membangun ketenangan pada jiwa.** Sebagaimana firman Allah: *> "Litaskunu ilaiha..." (Agar kalian merasa tenteram bersamanya).*
* **Melanjutkan keturunan yang sah.** Menikah menjaga nasab dan membentuk keluarga yang bertanggung jawab.
* **Menjalankan Sunnah Rasulullah ﷺ.** Pernikahan disyariatkan sebagai bentuk kesempurnaan ibadah.
            ''',
            'reference': '''
- QS. Ar-Rum: 21
- HR. Bukhari & Muslim
- HR. Abu Dawud
- Kifayatul Akhyar, Abu Bakr al-Hishni
            '''
          },
          {
            'title': 'Hukum Pernikahan',
            'content': '''
Dalam islam, hukum pernikahan tidak tunggal. Ulama menyebutkan bahwa hukumnya bisa menjadi wajib, sunnah, makruh, bahkan haram, tergantung kondisi seseorang.

### Pembagian Hukum Pernikahan
* **Wajib**: Bila seseorang sudah mampu secara lahir dan batin, dan ia khawatir terjerumus dalam zina jika tidak menikah.
* **Sunnah**: Jika seseorang mampu, tetapi tidak takut terjerumus dalam zina. Ini hukum yang paling umum.
* **Haram**: Jika orang itu berniat menyakiti pasangannya, atau tidak mampu menunaikan kewajiban suami/istri.
* **Makruh**: Jika seseorang khawatir terjatuh pada dosa dan mara bahaya jika menikah, seperti khawatir tidak mampu memberi nafkah atau berbuat jelek kepada keluarga.

### Kesimpulan
Hukum pernikahan dalam islam bersifat kondisional. Setiap individu perlu melihat kesiapan, niat, dan keadaan pribadinya sebelum memutuskan untuk menikah.
            ''',
            'reference': 'Mazhab Syafi’i'
          },
          {
            'title': 'Memilih Pasangan',
            'content': '''
Dalam Islam, memilih pasangan bukan sekadar urusan cinta, tapi bagian dari langkah membangun rumah tangga yang sakinah, mawaddah, dan rahmah.

### Kriteria Ideal Memilih Pasangan
1.  **Agama dan Akhlak**. Ini adalah kriteria utama. Rasulullah ﷺ bersabda: *> “Maka pilihlah yang beragama, niscaya engkau akan beruntung.”*
2.  **Keseimbangan (Kafa’ah)**. Dalam mazhab Syafi’i, kafa’ah mencakup kesetaraan dalam hal agama, moral, status sosial, dan kemampuan ekonomi.
3.  **Keturunan dan Nasab yang Baik**. Menjadi pertimbangan untuk menjaga silsilah dan kehormatan keluarga.
4.  **Kematangan Emosi dan Tanggung Jawab**. Pasangan harus siap secara mental, emosional, dan sosial.

Pasangan yang baik bukan hanya yang menyenangkan hati, tapi juga mendekatkan diri kepada Allah.
            ''',
            'reference': '''
- HR. Bukhari dan Muslim
- Fiqih Islam wa Adillatuhu, Wahbah az-Zuhaili
            '''
          },
          {
            'title': 'Khitbah (Peminangan)',
            'content': '''
Khitbah adalah proses permintaan secara resmi untuk menikah. Hukumnya mubah (boleh), namun bisa menjadi sunnah.

### Adab dan Tata Cara Khitbah
* Melibatkan wali perempuan sebagai bentuk penghormatan.
* Meneliti calon pasangan (melihat wajah dan telapak tangan).
* Menjaga batasan syariat (tidak boleh berkhalwat karena belum mahram).
* Tidak tergesa-gesa menuntut keputusan.

### Larangan dalam Khitbah
* Melamar wanita yang sedang dalam masa pinangan orang lain.
* Berperilaku seolah sudah menjadi pasangan resmi (pacaran).

Khitbah adalah langkah serius menuju pernikahan, bukan ajang coba-coba.
            ''',
            'reference': '''
- Fathul Qarib, Bab Nikah
- HR. Abu Dawud, Tirmidzi
- HR. Bukhari dan Muslim
            '''
          },
          {
            'title': 'Syarat dan Rukun Nikah',
            'content': '''
Agar pernikahan dinyatakan sah secara syar’i, harus terpenuhi rukun dan syarat nikah. Jika salah satu rukun tidak terpenuhi, maka akad nikah menjadi tidak sah.

### Rukun Nikah (Mazhab Syafi’i)
1.  **Calon Suami**: Laki-laki yang jelas, tidak dalam ihram, dan tidak ada halangan menikah.
2.  **Calon Istri**: Perempuan yang halal dinikahi (bukan mahram, tidak dalam masa iddah).
3.  **Wali Nikah**: Wali sah dari pihak perempuan. Akad tanpa wali tidak sah.
4.  **Dua Orang Saksi**: Laki-laki, adil, dan memahami maksud akad.
5.  **Ijab dan Kabul**: Ucapan akad yang jelas dan bersambung.

### Syarat Penting Nikah
* Ridha kedua mempelai (tidak ada paksaan).
* Wali harus laki-laki muslim dan adil.
* Saksi harus laki-laki, baligh, dan adil.
* Tidak ada nikah mut’ah (pernikahan sementara).
* Tidak dalam masa ihram haji/umrah.
            ''',
            'reference': '''
- Fathul Qarib, Bab Nikah
- Kifayatul Akhyar, Kitab an-Nikah
- HR. Bukhari
            '''
          },
          {
            'title': 'Adab Sebelum Menikah',
            'content': '''
Adab sebelum menikah adalah serangkaian etika yang dianjurkan Islam agar proses menuju pernikahan mendatangkan keberkahan.

### Adab yang Dianjurkan
* **Meluruskan Niat**: Menikah untuk ibadah, bukan karena tren atau pelarian.
* **Bertanya kepada orang alim atau orang tua**: Jangan terburu-buru memilih pasangan.
* **Istikharah**: Memohon petunjuk Allah sebelum mengambil keputusan.
* **Menjaga Interaksi**: Calon pasangan belum mahram, maka interaksi harus dalam batas syar’i.
* **Mempelajari Hak dan Kewajiban**: Bekal ilmu sebelum berumah tangga.
* **Ta'aruf dengan adab**, bukan pacaran.

### Larangan yang Harus Dihindari
* Berkhalwat (berduaan tanpa mahram).
* Berpacaran bebas tanpa batasan syariat.
* Memperlakukan khitbah seolah-olah sudah akad.
            ''',
            'reference': '''
- HR. Bukhari dan Muslim
- HR. Bukhari
            '''
          },
          {
            'title': 'Persiapan Mental dan Spiritual',
            'content': '''
Persiapan pernikahan harus menyeluruh, baik dari aspek mental maupun spiritual.

### Persiapan Mental
* **Kematangan Emosional**: Mampu mengelola emosi dan bersikap bijak.
* **Kesadaran Akan Tanggung Jawab**: Siap menerima peran sebagai suami atau istri.
* **Komitmen Jangka Panjang**: Siap untuk bertahan dan memperbaiki keadaan saat konflik.
* **Kesiapan Berkomunikasi**: Mampu mencari solusi bersama.

### Persiapan Spiritual
* **Menguatkan Hubungan dengan Allah**: Perbaiki kualitas ibadah.
* **Meluruskan Niat**: Niat menikah untuk ibadah dan menjalankan sunnah.
* **Bertaubat dan Membersihkan Diri**: Meninggalkan kebiasaan buruk.
* **Melaksanakan Salat Istikharah**: Meminta petunjuk Allah.
            ''',
            'reference': '''
- HR. Bukhari dan Muslim
- HR. Bukhari
            '''
          },
        ],
      },
      {
        'title': 'Nikah',
        'icon': Icons.favorite,
        'gradient': [Colors.green[300]!, Colors.green[500]!],
        'subMenus': [
          {
            'title': 'Akad Nikah',
            'content': '''
Akad nikah adalah perjanjian suci antara laki-laki dan perempuan sesuai syariat Islam. Akad ini bersifat sakral dan penuh tanggung jawab, sebagaimana firman Allah:
> “...dan mereka (istri-istrimu) telah mengambil dari kamu perjanjian yang kuat (mitsaqan ghaliza).”

### Rukun Akad Nikah (Mazhab Syafi’i)
1.  **Calon Suami**
2.  **Calon Istri**
3.  **Wali Nikah** (Pernikahan tidak sah tanpa wali)
4.  **Dua Orang Saksi** (Laki-laki muslim, baligh, adil)
5.  **Ijab dan Kabul** (Diucapkan dalam satu majelis, jelas, dan bersambung)

Akad nikah adalah inti dari pernikahan, bukan sekadar formalitas.
            ''',
            'reference': '''
- QS. An-Nisa: 21
- Fathul Qarib, Bab Nikah
- Kifayatul Akhyar, Kitab an-Nikah
            '''
          },
          {
            'title': 'Saksi Nikah',
            'content': '''
Saksi nikah adalah dua orang yang hadir dan menyaksikan langsung akad nikah. Kehadiran saksi adalah **rukun nikah** menurut mayoritas ulama.

### Syarat Saksi Nikah dalam Islam
* **Laki-laki**: Harus dua orang laki-laki.
* **Muslim**: Saksi harus beragama Islam.
* **Baligh dan Berakal**: Bukan anak-anak atau orang yang tidak waras.
* **Adil**: Memiliki reputasi baik, tidak fasik.
* **Mendengar dan Memahami Akad**: Harus hadir dan mengerti prosesi.

### Fungsi dan Tujuan Kehadiran Saksi
* Menegaskan bahwa akad terjadi secara terbuka.
* Menjaga keabsahan pernikahan.
* Menjadi bukti bila suatu saat terjadi sengketa.
            ''',
            'reference': '''
- HR. Tirmidzi
- Fiqih Islam wa Adillatuhu, Jilid 7
            '''
          },
          {
            'title': 'Mahar (Maskawin)',
            'content': '''
Mahar (ṣadāq) adalah pemberian **wajib** dari laki-laki kepada perempuan sebagai bentuk penghormatan dan syarat sah pernikahan.

> “Berikanlah mahar kepada wanita (yang kamu nikahi) sebagai pemberian yang penuh kerelaan.”

### Hukum Mahar
* **Wajib** (fardhu) sebagai bagian dari rukun atau syarat.
* Tidak ada batas minimal, namun harus sesuatu yang bernilai dan halal.
* Boleh tidak diserahkan langsung, tetapi wajib disepakati.

### Bentuk Mahar
* Uang tunai atau barang berharga.
* Manfaat tertentu, seperti mengajarkan Al-Qur’an.

Islam menganjurkan untuk **memudahkan mahar**, bukan mempersulit.
            ''',
            'reference': '''
- QS. An-Nisa: 4
- HR. Bukhari dan Muslim
- HR. Abu Dawud
            '''
          },
          {
            'title': 'Walimah (Resepsi)',
            'content': '''
Walimah adalah jamuan makan atau syukuran yang diselenggarakan suami setelah akad nikah sebagai bentuk syukur dan pengumuman.

### Hukum Walimah
**Sunnah muakkadah** (sangat dianjurkan). Rasulullah ﷺ bersabda:
> “Adakanlah walimah, meskipun hanya dengan seekor kambing.”

### Adab Walimah
* Tidak berlebihan atau boros.
* Menjaga syariat (tidak ada maksiat, campur baur, atau membuka aurat).
* Mengundang orang miskin, tidak hanya orang kaya.
* Tidak memaksakan diri secara finansial.

Walimah adalah bentuk syukur dan pengumuman resmi atas pernikahan yang sah.
            ''',
            'reference': '''
- HR. Bukhari dan Muslim
            '''
          },
          {
            'title': 'Doa-doa Pernikahan',
            'content': '''
Doa memiliki peran penting dalam pernikahan untuk memohon keberkahan, menjaga niat, dan melindungi rumah tangga.

### Doa untuk Pengantin
> **بَارَكَ اللَّهُ لَكَ، وَبَارَكَ عَلَيْكَ، وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ**
>
> *Bārakallāhu laka, wa bāraka ‘alaika, wa jama‘a bainakumā fī khair.*
>
> "Semoga Allah memberkahimu, memberkahi atasmu, dan menyatukan kalian berdua dalam kebaikan."

### Doa Agar Keluarga Sakinah
> **رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ، وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا**
>
> *Rabbana hab lana min azwājinā wa dhurriyyātinā qurrata a‘yun, waj‘alnā lil-muttaqīna imāmā.*
>
> "Ya Tuhan kami, anugerahkanlah kepada kami pasangan kami dan keturunan kami sebagai penyejuk hati, dan jadikanlah kami pemimpin bagi orang-orang yang bertakwa."

### Doa Pengantin pada Malam Pertama
> **اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ خَيْرِهَا، وَخَيْرِ مَا جَبَلْتَهَا عَلَيْهِ، وَأَعُوذُ بِكَ مِنْ شَرِّهَا، وَشَرِّ مَا جَبَلْتَهَا عَلَيْهِ**
>
> *Allāhumma innī as’aluka min khairihā wa khairi mā jabaltahā ‘alaihi, wa a‘ūdzu bika min sharrihā wa sharri mā jabaltahā ‘alaihi.*
>
> "Ya Allah, aku memohon kepada-Mu kebaikannya dan kebaikan tabiatnya, dan aku berlindung kepada-Mu dari kejahatannya dan kejahatan tabiatnya."
            ''',
            'reference': '''
- QS. Ali Imran: 195
- HR. Abu Dawud, Tirmidzi, dan Ibnu Majah
- QS. Al-Furqan: 74
- QS. As-Saffat: 100
- HR. Abu Dawud dan Ibnu Majah
- Riyadhus Shalihin – Imam Nawawi
            '''
          },
        ],
      },
      {
        'title': 'Pasca Nikah',
        'icon': Icons.home_filled,
        'gradient': [Colors.blue[300]!, Colors.blue[500]!],
        'subMenus': [
          {
            'title': 'Hak dan Kewajiban Suami Istri',
            'content': '''
Kehidupan rumah tangga dibangun atas dasar saling melengkapi. Syariat telah menetapkan hak dan kewajiban masing-masing pihak secara adil.

### Kewajiban Suami terhadap Istri
* **Menafkahi** istri secara lahir dan batin.
* **Memimpin** dan membimbing istri dalam kebaikan dan agama.
* Memberikan **perlindungan** dan rasa aman.
* Bersikap **adil** (jika berpoligami).

### Kewajiban Istri terhadap Suami
* **Taat** kepada suami dalam hal yang ma’ruf.
* **Menjaga kehormatan** diri dan harta suami.
* **Melayani** kebutuhan suami dengan baik.
* **Mendidik** dan merawat anak-anak sebagai madrasah pertama.

Suami adalah pemimpin, tetapi bukan penguasa. Istri adalah pendamping, bukan bawahan.
            ''',
            'reference': '''
- QS. Al-Baqarah: 228
- QS. An-Nisa: 34
- Fiqih Sunnah, Sayyid Sabiq
            '''
          },
          {
            'title': 'Adab Bergaul Suami Istri',
            'content': '''
Pernikahan adalah ikatan batiniah yang dijaga dengan adab dan akhlak.
> “Dan bergaullah dengan mereka secara patut (ma’ruf)...”

### Adab Suami terhadap Istri
* Lemah lembut dalam perkataan dan perbuatan.
* Memuliakan dan menghargai istri.
* Mendengarkan dan berdiskusi.
* Bersikap romantis dan menyenangkan hati.

### Adab Istri terhadap Suami
* Berbicara dengan sopan dan lembut.
* Menunjukkan penghargaan dan rasa syukur.
* Menjaga wibawa suami.
* Merawat diri di hadapan suami.

### Adab Bersama
* Saling mendoakan dan memaafkan.
* Menjaga rahasia rumah tangga.
* Menghindari sikap egois.
            ''',
            'reference': '''
- QS. An-Nisa: 19
- Fiqih Islam wa Adillatuhu, Wahbah az-Zuhaili
            '''
          },
          {
            'title': 'Nafkah dalam Islam',
            'content': '''
Nafkah adalah segala bentuk pemenuhan kebutuhan lahiriah istri dan keluarga, yang menjadi **kewajiban suami**.
> “...karena mereka (para suami) menafkahkan hartanya...”

### Hukum Memberi Nafkah
* **Wajib** (fardu ‘ain) atas suami terhadap istrinya yang sah.
* Kewajiban tetap berlaku meskipun istri kaya.

### Bentuk Nafkah
* Makanan dan Minuman.
* Pakaian yang layak.
* Tempat Tinggal yang aman.
* Biaya Kesehatan, Pendidikan Anak, dll.

### Prinsip dalam Memberi Nafkah
* Sesuai kemampuan suami.
* Dengan cara yang baik dan tanpa penghinaan.

### Nafkah Batal Bila...
Istri ***nusyuz*** (durhaka), seperti meninggalkan rumah tanpa izin atau menolak hubungan tanpa alasan syar’i.
            ''',
            'reference': '''
- QS. An-Nisa: 34
- HR. Muslim
- QS. At-Talaq: 7
            '''
          },
          {
            'title': 'Mendidik Anak',
            'content': '''
Anak adalah **amanah** dari Allah Swt. yang harus dididik dengan baik.
> “Setiap anak dilahirkan dalam keadaan fitrah, maka kedua orang tuanyalah yang menjadikannya Yahudi, Nasrani, atau Majusi.”

### Tujuan Pendidikan Anak dalam Islam
* Menumbuhkan akidah dan keimanan yang kuat.
* Membentuk akhlak mulia.
* Menanamkan kecintaan terhadap ilmu dan amal saleh.
* Menjadikan anak sebagai penyejuk hati (*qurrata a’yun*).

### Prinsip Mendidik Anak dalam Islam
* Dimulai dari teladan orang tua.
* Mendidik dengan kasih sayang dan hikmah.
* Memberi batasan dan disiplin yang seimbang.
* Menyesuaikan pendidikan dengan tahap usia.

### Nilai-Nilai Utama yang Harus Ditanamkan
* Tauhid dan keimanan.
* Shalat dan ibadah sejak dini.
* Kejujuran, tanggung jawab, dan adab.
* Kemandirian dan semangat belajar.
            ''',
            'reference': '''
- HR. Bukhari dan Muslim
- QS. Al-Furqan: 74
- HR. Abu Dawud
- Tarbiyatul Aulad fil Islam, Abdullah Nashih Ulwan
            '''
          },
          {
            'title': 'Mengatasi Konflik Rumah Tangga',
            'content': '''
Konflik dalam rumah tangga adalah hal yang alami. Islam memberikan panduan agar konflik tidak berakhir dengan kehancuran, melainkan menjadi wasilah untuk saling memahami.

### Penyebab Umum Konflik
* Kurangnya komunikasi.
* Perbedaan latar belakang.
* Masalah ekonomi atau nafkah.
* Cemburu berlebihan atau kurangnya kepercayaan.
* Campur tangan pihak ketiga.

### Panduan Islam dalam Menyelesaikan Konflik
1.  **Introspeksi Diri (Muhasabah)**. Koreksi diri sebelum menyalahkan.
2.  **Musyawarah dan Komunikasi Jujur**. Berdialog dengan empati.
3.  **Sabar dan Menahan Emosi**.
4.  **Tidak Mengungkit Masa Lalu**. Fokus pada solusi.
5.  **Minta Nasihat dari Penengah (Hakam)**. Jika buntu, libatkan penengah yang adil dari keluarga masing-masing.
6.  **Jangan Umbar di Media Sosial**. Menjaga aib rumah tangga adalah wajib.
            ''',
            'reference': '''
- QS. At-Tahrim: 6
- HR. Bukhari dan Muslim
- QS. An-Nisa: 35
            '''
          },
        ],
      },
    ];

    final batch = db.batch();

    for (var categoryData in initialData) {
      final categoryId = await db.insert('categories', {
        'title': categoryData['title'],
        'iconCodePoint': (categoryData['icon'] as IconData).codePoint,
        'startColor': (categoryData['gradient'] as List<Color>)[0].value,
        'endColor': (categoryData['gradient'] as List<Color>)[1].value,
      });

      for (var subMenuData
          in categoryData['subMenus'] as List<Map<String, dynamic>>) {
        final subMenuTitle = subMenuData['title'] as String;
        final content = subMenuData['content'] as String;
        final reference = subMenuData['reference'] as String;

        batch.insert('sub_menus', {
          'title': subMenuTitle,
          'categoryId': categoryId,
        });

        batch.insert('contents', {
          'subMenuTitle': subMenuTitle,
          'content': content.trim(),
          'reference': reference.trim(),
        });
      }
    }

    await batch.commit(noResult: true);
  }

  Future<List<MenuCategory>> getAllCategoriesWithSubMenus() async {
    final db = await database;
    final List<Map<String, dynamic>> categoryMaps =
        await db.query('categories');
    final List<MenuCategory> categories = [];

    for (var categoryMap in categoryMaps) {
      final category = MenuCategory.fromMap(categoryMap);
      final List<Map<String, dynamic>> subMenuMaps = await db.query(
        'sub_menus',
        where: 'categoryId = ?',
        whereArgs: [category.id],
      );
      category.subMenus = subMenuMaps.map((sm) => SubMenu.fromMap(sm)).toList();
      categories.add(category);
    }

    return categories;
  }

  Future<Content?> getContentBySubMenuTitle(String subMenuTitle) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contents',
      where: 'subMenuTitle = ?',
      whereArgs: [subMenuTitle],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Content.fromMap(maps.first);
    }
    return null;
  }
}
