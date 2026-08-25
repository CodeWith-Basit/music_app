class Song {
  final String title;
  final String artist;
  final String songPath;
  final String imagePath;

  const Song({
    required this.title,
    required this.artist,
    required this.songPath,
    required this.imagePath,
  });
}

final List<Song> songList = [
  const Song(
    title: 'Bhula Dena',
    artist: 'Mustafa Zahid',
    songPath: 'assets/songs/07 - Bhula Dena - DownloadMing.SE.mp3',
    imagePath: 'assets/images/bhula_dena.jpeg',
  ),
  const Song(
    title: 'Deewana Kar Raha Hai',
    artist: 'Javed Ali',
    songPath:
        'assets/songs/Deewana Kar Raha Hai- slowed and reverb - axonnaru.mp3',
    imagePath: 'assets/images/dewana_kar_raha_hai.jpg',
  ),
  const Song(
    title: 'Dillagi',
    artist: 'Rahat Fateh Ali Khan',
    songPath: 'assets/songs/Dillagi - Rahat Fateh Ali Khan(MyMp3Song).mp3',
    imagePath: 'assets/images/dillagi.jpg',
  ),
  const Song(
    title: 'Lat Lag Gayi',
    artist: 'Benny Dayal & Shalmali',
    songPath: 'assets/songs/lat-lag-gaye.mp3',
    imagePath: 'assets/images/lat_lag_gayi.jpg',
  ),
  const Song(
    title: 'Majboor',
    artist: 'Raag World',
    songPath: 'assets/songs/Majboor - RaagWorld.mp3',
    imagePath: 'assets/images/majboor.jpg',
  ),
  const Song(
    title: 'Sitaare',
    artist: 'Arijit Singh',
    songPath: 'assets/songs/sitaare.mp3',
    imagePath: 'assets/images/sitaare.jpg',
  ),
  const Song(
    title: 'Toh Phir Aao',
    artist: 'Mustafa Zahid',
    songPath: 'assets/songs/Toh Phir Aao Awarapan 320 Kbps.mp3',
    imagePath: 'assets/images/toh_phir_ao.jpg',
  ),
  const Song(
    title: 'Tu Hi Haqeeqat',
    artist: 'Javed Ali',
    songPath: 'assets/songs/tu-hi-haqeeqat.mp3',
    imagePath: 'assets/images/tu_hi_haqeeqat.jpg',
  ),
  const Song(
    title: 'Ya Ali',
    artist: 'Zubeen Garg',
    songPath: 'assets/songs/Ya Ali.mp3',
    imagePath: 'assets/images/ya_ali.jpg',
  ),
];
