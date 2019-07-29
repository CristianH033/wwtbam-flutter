import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Player {
  static bool playingLoop = false;
  static AudioPlayer player = AudioPlayer();
  static AudioPlayer playerLoop = AudioPlayer();
  static AudioCache cache = AudioCache(prefix: 'sonidos/');
  static List sonidos = const ['break.mp3', 'correct.mp3', 'lets_play.mp3', 'main.mp3', 'main_theme.mp3', 'final_answer.mp3', 'wrong.mp3'];
  
  static final Player _player = new Player._internal();

  factory Player() {
    AudioPlayer.logEnabled = false;
    cache.loadAll(sonidos);
    return _player;
  }

  Player._internal();

  static Future playIntro() async {
    // playingLoop = true;
    // playerLoop = await cache.loop('main_theme.mp3', isNotification: false);
  }

  static Future playMain() async {
    // playingLoop = true;
    // playerLoop = await cache.loop('main.mp3', isNotification: false);
  }

  static Future playCorrect() async {
    // player = await cache.play('correct.mp3', isNotification: false);
  }

  static Future playLetsPlay() async {
    // player = await cache.play('lets_play.mp3', isNotification: false);
  }

  static Future playBreak() async {
    // player = await cache.play('break.mp3', isNotification: false);
  }

  static Future playWrong() async {
    // player = await cache.play('wrong.mp3', isNotification: false);
  }

  static Future playFinal() async {
    // player = await cache.play('final_answer.mp3', isNotification: false);
  }

  static void pauseLoop(){
    // playerLoop.pause();
  }

  static void resumeLoop(){
    if(playingLoop){
      // playerLoop.resume();
    }
  }

  static stop() {
    // playingLoop = false;
    // player.stop();
    // playerLoop.stop();
  } 
}
