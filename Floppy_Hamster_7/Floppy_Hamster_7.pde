import processing.sound.*;
SoundFile inicio, ambiente, punto, perdiste, ganaste, ouch, pop, boing;
import fisica.*;

//fisica
FWorld mundo;

//Fuente
PFont texto;
PFont textoT;

//Imagenes
PImage platMov;
PImage platRot;
PImage platRotLarg;
PImage platRotLarg1;
PImage platFija;
PImage platAbajo;
PImage boliche;
PImage bbolgrand;
PImage PinchosDer;
PImage PinchosIzq;
PImage PinchosAbajo;
PImage Ancla;
PImage burbuja;
PImage platCirc;
PImage Fondo;
PImage punito;
PImage Cadena;
PImage CircInmG;
PImage CircInmP;
PImage Ascensor;
PImage Caja;
PImage libPunete;
PImage boxPunete;
PImage botonReiniciar;
//secuencia img
int maxImages = 3;
int imageIndex = 0;

ArrayList <Semilla> semillas;
PImage [] images = new PImage[maxImages];

//Parametros
String estado;
int puntos;


String Estado;

Pantalla p;
int xi, yi, xa, ya, xd, yd, aa;

int begin;
int duracion;
int time;
boolean termino;

boolean juegoEstaIniciado;

//fisica
FBox costado, abajo;

//
Hamster hamster;
Plataforma base1, base2, base3, base4, base6, base7, base8, base11, boton;
Plat_Circular baseC1, baseC2, baseC3;

void setup() {
  size(1600, 900);
  //semillas = new ArrayList <Semilla> ();

  texto= createFont ("Sketchtica.ttf", 30);
  textoT = createFont ("KGSummerSunshine.ttf", 135);

  //fisica
  Fisica.init(this);
  mundo = new FWorld();
  mundo.setEdges();

  //secuencia img
  for (int i = 0; i < images.length; i++) {
    images[i] = loadImage("inicio_" + i + ".png");
  }
  frameRate(15);

  //Sonido
  inicio = new SoundFile (this, "ambiente1.mp3");
  ambiente = new SoundFile (this, "ambiente.mp3");
  perdiste= new SoundFile (this, "perdiste.mp3");
  ganaste= new SoundFile (this, "ganaste.mp3");
  punto= new SoundFile (this, "punto.mp3");
  ouch= new SoundFile (this, "ouch.mp3");
  pop= new SoundFile (this, "pop.mp3");
  boing= new SoundFile (this, "boing.mp3");


  xi = 340;
  yi = 110;
  xa = 350;
  ya = 25;
  xd = 720;
  yd = 50;
  aa = 100;

  //Contador
  time = duracion = 20;
  termino = false;

  juegoEstaIniciado = false;

  p = new Pantalla();


  //Imagenes
  platMov = loadImage("Plataforma_Que_Se_Puede_Sacar.png");
  platRot = loadImage("Plataforma_Que_Rota.png");
  platRotLarg = loadImage("PlatGiraLarg.png");
  platRotLarg1 = loadImage("PlatGiraLarg1.png");
  platFija = loadImage("Plataforma_Fija_.png");
  boliche = loadImage("bboliche.PNG");
  bbolgrand = loadImage("BolaMasGrande.PNG");
  Fondo = loadImage("fondoPapel.png");
  PinchosAbajo = loadImage("Parte_De_Abajo.png");
  PinchosIzq = loadImage("CostadoIzq.png");
  PinchosDer = loadImage("CostadoDer.png");
  platAbajo = loadImage("Plat_De_Abajo.png");
  Ancla = loadImage("Ancla.png");
  burbuja = loadImage("Burbuja.png");
  platCirc = loadImage("PlataformaCirc .png");
  punito = loadImage("punito.PNG");
  CircInmG = loadImage("circInm1.PNG");
  CircInmP = loadImage("circInm3.PNG");
  Cadena = loadImage("cadena.PNG");
  Ascensor = loadImage("ascensor.PNG");
  Caja = loadImage("Caja.PNG");
  libPunete = loadImage("liberarpuñete.png");
  boxPunete = loadImage("boxpuñete.PNG");
  botonReiniciar = loadImage("botonReinicio.png");

  //for (int i = 0; i <3; i++) {
  //  Semilla s = new Semilla();
  //  semillas.add(s);
  //}
  //Iniciar juego
  estado = "Inicio";
  inicio.loop();
  inicio.amp(0.5);
}

void draw() {
  println(mouseX, mouseY);
  switch(estado) {
  case "Inicio":
    perdiste.stop();
    ganaste.stop();
    //p.dibujar(0);
    //secuencia img
    image(images[imageIndex], 0, 0);
    imageIndex = (imageIndex+1) % images.length;
    
    //textSize(50);
    fill(0);
    textFont(texto);
    textAlign(CENTER);
    text("Aprieta ENTER para empezar", width/2, height-30);
    //textSize(150);
    textFont(textoT);
    text("FLOPPY HAMSTER", width/2, 200);
    break;
  case "Instruc":
    p.dibujar(1);
    break;
  case "inicializaJuego":
    if (!juegoEstaIniciado) {
      iniciarJuego();
      inicio.stop();
      ambiente.loop();
      ambiente.amp(0.2);
      juegoEstaIniciado = true;
      estado = "estaJugando";
    } else {
      juegoEstaIniciado = false;
      mundo.clear();
    }
    break;
  case "estaJugando":
    image(Fondo, 0, 0);

    mundo.step();
    mundo.draw();


    //-----------------------------------------------------------

    //Line
    stroke(10);
    line(0, height-100, width, height-100);

    //contador
    if (time > 0) {
      time = duracion -(millis()-begin)/1000;
      textSize(50);
      fill(0);
      textFont(texto);
      textAlign(CENTER);
      text("TIEMPO: "+ time, width/2, 840);
    } else {
      textSize(50);
      fill(0);
      textAlign(CENTER);
      textFont(texto);
      text("TIEMPO: "+ time, width/2, 840);
      termino = true;
      ambiente.stop();
      perdiste.play();
      perdiste.loop();
    }

    text("Puntos:"+puntos, width/2, 880);
    break;

  case "Perdiste":
    p.dibujar(2);

    break;
  case "Ganaste":
    p.dibujar(3);
    break;
  }

  //Perder por tiempo
  if (getTermino()) {
    estado = "Perdiste";
    reciclarVar();
  }
}

/////////////////////////////PASAJE DE ESTADOS/////////////////////////////
void keyPressed() {

  switch(estado) {
  case "Inicio":
    if (key == ENTER) {
      estado = "Instruc";
    }
    break;
  case "Instruc":
    if (key == ENTER) {
      estado = "inicializaJuego";
      semillas = new ArrayList <Semilla> ();
      for (int i = 0; i <3; i++) {
        Semilla s = new Semilla();
        semillas.add(s);
      }
      //println("se ejecuta");
      //Semillas
      semillas.get(0).inicializar(540, 510);
      semillas.get(1).inicializar(1097, 527);
      semillas.get(2).inicializar(1497, 355);
      puntos = 0;
      reciclarVar();
    }
    break;
  case "Perdiste":
    if (key == ENTER) {
      for (int i=0; i < semillas.size(); i++)
      {
        semillas.get(i).resetear();
      }
      estado = "Inicio";
      inicio.loop();
      inicio.amp(0.5);
    }
    break;
  case "Ganaste":
    if (key==ENTER) {
      // for (int i=0; i < semillas.size(); i++)
      //{
      //  semillas.get(i).resetear();
      //}
      estado="Inicio";
      inicio.loop();
      inicio.amp(0.5);
    }
    break;
  }
}


void iniciarJuego() {

  //Personaje
  hamster = new Hamster(80);
  hamster.inicializar(140, 96);
  mundo.add(hamster);

  //Semillas
  //semillas.get(0).inicializar(540, 570);
  //semillas.get(1).inicializar(1097, 527);
  //semillas.get(2).inicializar(1497, 355);

  //-----------------------------------------------------------
  //Pinchos del lado derecho
  Bordes pinchosder = new Bordes(30, 800);
  pinchosder.inicializar(20, 400);
  pinchosder.attachImage(PinchosIzq);
  mundo.add(pinchosder);

  //Pinchos del lado Izquierdo
  Bordes pinchosizq = new Bordes(30, 800);
  pinchosizq.inicializar(1580, 400);
  pinchosizq.attachImage(PinchosDer);
  mundo.add(pinchosizq);

  //Pinchos de abajo
  Bordes pinchosabajo = new Bordes(1600, 30);
  pinchosabajo.inicializar(800, 785);
  pinchosabajo.attachImage(PinchosAbajo);
  mundo.add(pinchosabajo);

  //-----------------------------------------------------------
  //Barra que gira
  //Base 0 (3 - 23) camino1
  FCircle ancla0 = new FCircle(20);
  ancla0.setPosition(128, 303);
  ancla0.setStatic(true);
  ancla0.attachImage(Ancla);
  mundo.add(ancla0);

  FBox movimiento0 = new FBox(200, 30);
  movimiento0.setPosition(128, 303);
  //movimiento0.setFill(173, 69, 17);
  //movimiento0.setNoStroke();
  movimiento0.attachImage(platRotLarg1);
  mundo.add(movimiento0);

  FRevoluteJoint revolute0 = new FRevoluteJoint (ancla0, movimiento0);
  mundo.add(revolute0);

  //Base 1 (3 - 23) plataforma diagonal
  FCircle point = new FCircle(20);
  point.setPosition(225, 536);
  point.setStatic(true);
  point.attachImage(Ancla);
  mundo.add(point);

  FBox movimiento = new FBox(150, 30);
  movimiento.setPosition(225, 536);
  movimiento.setRotation(16.6);
  movimiento.attachImage(platRotLarg);
  movimiento.setFill(173, 69, 17);
  movimiento.setNoStroke();
  mundo.add(movimiento);

  FRevoluteJoint revolute = new FRevoluteJoint (point, movimiento);
  mundo.add(revolute);

  //Base 2 (6- 26) camino 2 izq
  PlatGira pgira2 = new PlatGira(150, 30);
  pgira2.inicializar(1030, 300);
  mundo.add(pgira2.ancla);
  mundo.add(pgira2.movimiento);
  mundo.add(pgira2.revolute);

  //Base 3 (7 - 27) camino 2 der
  PlatGira pgira3 = new PlatGira(150, 30);
  pgira3.inicializar(1195, 300);
  mundo.add(pgira3.ancla);
  mundo.add(pgira3.movimiento);
  mundo.add(pgira3.revolute);

  //Base 4 (8 9 - 58 59) base catapulta
  FCircle ancla2 = new FCircle(20);
  ancla2.setPosition(1390, 655);
  ancla2.setStatic(true);
  ancla2.attachImage(Ancla);
  mundo.add(ancla2);

  FBox movimiento2 = new FBox(270, 30);
  movimiento2.setPosition(1390, 655);
  movimiento2.attachImage(platRotLarg);
  movimiento2.setNoStroke();
  mundo.add(movimiento2);

  FRevoluteJoint revolute2 = new FRevoluteJoint (ancla2, movimiento2);
  mundo.add(revolute2);

  //-----------------------------------------------------------
  //Bola demoledora / Wrecking ball
  BolaDemoler bolDem = new BolaDemoler(40, 40);
  bolDem.inicializar(1030, 400);
  bolDem.bola.attachImage(bbolgrand);
  mundo.add(bolDem.eje);
  mundo.add(bolDem.bola);
  mundo.add(bolDem.cadena);

  //Caja del Puñete
  FBox eje = new FBox(40, 40);
  eje.setStatic(true);
  //eje.setPosition(465, 195);
  eje.setPosition(445, 195);
  eje.attachImage(Caja);
  mundo.add(eje);

  //Puñete
  FCircle puño = new FCircle(70);
  //puño.setPosition(546, 195);
  puño.setPosition(526, 195);
  puño.attachImage(punito);
  puño.setRotatable(false);
  mundo.add(puño);

  FDistanceJoint cadena = new FDistanceJoint(eje, puño);
  cadena.setLength(290);
  mundo.add(cadena);

  //-----------------------------------------------------------
  //Bola de boliche para catapulta
  //bolBol 2 (9 - 39)
  BolaBol bolaBol2 = new BolaBol(70);
  bolaBol2.inicializar(1440, 170);
  mundo.add(bolaBol2);

  //-----------------------------------------------------------
  //Barra estática
  //Base 1 (1 - 11)
  base1 = new Plataforma(150, 30);
  base1.setGrabbable(true);
  base1.inicializar (140, 145);
  base1.attachImage(platMov);
  mundo.add(base1/*.barra*/);

  //base 2 (1 - 31) diagonal resbala
  base2 = new Plataforma(150, 30);
  base2.setGrabbable(true);
  //base2.inicializar (518, 632);
  base2.inicializar (518, 560);
  base2.setRotation(10);
  base2.attachImage(platMov);
  mundo.add(base2/*.barra*/);

  //base 3 (10 - 310) to bolaBol de polea
  base3 = new Plataforma(150, 30);
  base3.setGrabbable(true);
  //base3.inicializar (340, 211);
  base3.inicializar (340, 190);
  base3.attachImage(platMov);
  mundo.add(base3);

  //base 4 (6 7 - 46 47) donde cae/bolaDemoler
  base4 = new Plataforma(150, 30);
  base4.setGrabbable(true);
  base4.inicializar (1100, 595);
  base4.attachImage(platMov);
  mundo.add(base4/*.barra*/);

  //base 5 (4 5 - 44 45) reemplaza rebote
  Plataforma base5 = new Plataforma(160, 40);
  base5.setGrabbable(false);
  base5.inicializar (655, 747);
  base5.attachImage(platAbajo);
  mundo.add(base5);

  //base 6 (9 - 39) to bolaBol catapulta
  base6 = new Plataforma(150, 30);
  base6.setGrabbable(true);
  base6.inicializar (1440, 230);
  base6.attachImage(platMov);
  mundo.add(base6/*.barra*/);

  //base 7 (diagonal) '''
  base7 = new Plataforma(150, 30);
  base7.setGrabbable(true);
  base7.inicializar (1194, 64);
  base7.setRotation(10);
  base7.attachImage(platMov);
  mundo.add(base7);

  //base 8 (diagonal) /
  base8 = new Plataforma(150, 30);
  base8.setGrabbable(true);
  //base8.inicializar (933, 194);
  base8.inicializar (933, 200);
  base8.setRotation(-10);
  base8.attachImage(platMov);
  mundo.add(base8);

  //base 9 (to puñete arriba)
  Plataforma base9 = new Plataforma(60, 20);
  base9.setGrabbable(false);
  base9.inicializar (566, 150);
  base9.attachImage(boxPunete);
  mundo.add(base9);

  //base 10 (to puñete abajo)
  Plataforma base10 = new Plataforma(60, 20);
  base10.setGrabbable(false);
  base10.inicializar (566, 240);
  base10.attachImage(boxPunete);
  mundo.add(base10);

  //Para Liberar al puño
  base11 = new Plataforma(20, 60);
  base11.setGrabbable(true);
  base11.inicializar (586, 195);
  base11.setFill(173, 69, 17, 185);
  base11.setNoStroke();
  base11.attachImage(libPunete);
  mundo.add(base11);

  //-----------------------------------------------------------
  //Círculos estáticos
  //baseC 1 to bolaDemoler
  baseC1 = new Plat_Circular(60);
  baseC1.inicializar (897, 390);
  baseC1.attachImage (platCirc);
  mundo.add(baseC1);

  //baseC 2 (6 - 46) to plataforma diagonal
  baseC2 = new Plat_Circular(60);
  baseC2.inicializar (163, 538);
  baseC2.attachImage (platCirc);
  mundo.add(baseC2);

  //baseC 3 (para catapulta)
  baseC3 = new Plat_Circular(30);
  baseC3.inicializar (1290, 687);
  baseC3.attachImage (platCirc);
  mundo.add(baseC3);

  //baseC 4 (para frenar el ascensor) izq
  Plat_Circular baseC4 = new Plat_Circular(30);
  baseC4.inicializar (640, 242);
  baseC4.attachImage(CircInmP);
  //baseC4.attachImage (platCirc);
  mundo.add(baseC4);

  //baseC 5 (para frenar el ascensor) der
  Plat_Circular baseC5 = new Plat_Circular(30);
  baseC5.inicializar (770, 242);
  baseC5.attachImage(CircInmP);
  mundo.add(baseC5);

  //-------------------------------------------------------
  //Plataforma rebote
  PlatRebo platRebo = new PlatRebo(160, 40);
  platRebo.inicializar(83, 747);
  platRebo.attachImage(platAbajo);
  mundo.add(platRebo);

  PlatRebo platRebo1 = new PlatRebo(160, 40);
  platRebo1.inicializar(368, 747);
  platRebo1.attachImage(platAbajo);
  mundo.add(platRebo1);

  PlatRebo platRebo2 = new PlatRebo(160, 40);
  platRebo2.inicializar(655, 747);
  platRebo2.attachImage(platAbajo);
  //mundo.add(platRebo2.platRebo);

  PlatRebo platRebo3 = new PlatRebo(160, 40);
  platRebo3.inicializar(945, 747);
  platRebo3.attachImage(platAbajo);
  mundo.add(platRebo3);

  PlatRebo platRebo4 = new PlatRebo(160, 40);
  platRebo4.inicializar(1231, 747);
  platRebo4.attachImage(platAbajo);
  mundo.add(platRebo4);

  PlatRebo platRebo5 = new PlatRebo(160, 40);
  platRebo5.inicializar(1517, 747);
  platRebo5.attachImage(platAbajo);
  mundo.add(platRebo5);

  //--------------------------------------------------------
  //Todo de polea

  //cadena
  FCircle cir1 = new FCircle(30);
  cir1.setPosition(xi, yi); //340,110
  cir1.attachImage(Cadena);
  cir1.setRotatable(false);
  mundo.add(cir1);

  FCircle cir2 = new FCircle(30);
  cir2.setPosition(xi, yi-30);
  cir2.attachImage(Cadena);
  cir1.setRotatable(false);
  mundo.add(cir2);

  FCircle cir3 = new FCircle(30);
  cir3.setPosition(xa, ya);//350,30
  cir3.attachImage(Cadena);
  cir1.setRotatable(false);
  mundo.add(cir3);

  FCircle cir4 = new FCircle(30);
  cir4.setPosition(xa+30, ya);
  cir4.attachImage(Cadena);
  cir1.setRotatable(false);
  mundo.add(cir4);

  FCircle cir5 = new FCircle(30);
  cir5.setPosition(xa+60, ya);
  cir5.attachImage(Cadena);
  mundo.add(cir5);

  FCircle cir6 = new FCircle(30);
  cir6.setPosition(xa+90, ya);
  cir6.attachImage(Cadena);
  mundo.add(cir6);

  FCircle cir7 = new FCircle(30);
  cir7.setPosition(xa+120, ya);
  cir7.attachImage(Cadena);
  mundo.add(cir7);
  //-------------------------------------------------------------------------------------------------
  FCircle cir8 = new FCircle(30);
  cir8.setPosition(xa+150, ya);
  cir8.attachImage(Cadena);
  //mundo.add(cir8);

  FCircle cir9 = new FCircle(30);
  //cir9.setPosition(xa+180, ya);
  cir9.setPosition(xa+150, ya);
  cir9.attachImage(Cadena);
  mundo.add(cir9);
  //-------------------------------------------------------------------------------------------------
  FCircle cir10 = new FCircle(30);
  cir10.setStatic(true);
  cir10.setPosition(xa+210, ya);
  cir10.attachImage(Cadena);
  //mundo.add(cir10);

  FCircle cir11 = new FCircle(30);
  //cir11.setPosition(xa+240, ya);
  cir11.setPosition(xa+180, ya);
  cir11.attachImage(Cadena);
  mundo.add(cir11);

  FCircle cir12 = new FCircle(30);
  //cir12.setPosition(xa+270, ya);
  cir12.setPosition(xa+240, ya);
  cir12.attachImage(Cadena);
  mundo.add(cir12);

  FCircle cir13 = new FCircle(30);
  //cir13.setPosition(xa+300, ya);
  cir13.setPosition(xa+270, ya);
  cir13.attachImage(Cadena);
  mundo.add(cir13);

  FCircle cir14 = new FCircle(30);
  cir14.setPosition(xd-30, ya);//680,50
  cir14.attachImage(Cadena);
  mundo.add(cir14);

  FCircle cir15 = new FCircle(30);
  cir15.setPosition(xd, yd);//710,50
  //cir15.setStatic(true);
  cir15.attachImage(Cadena);
  mundo.add(cir15);

  FCircle cir16 = new FCircle(30);
  cir16.setPosition(xd, yd+30);
  cir16.attachImage(Cadena);
  mundo.add(cir16);

  FCircle cir17 = new FCircle(30);
  cir17.setPosition(xd, yd+60);
  cir17.attachImage(Cadena);
  mundo.add(cir17);

  FCircle cir18 = new FCircle(30);
  cir18.setPosition(xd, yd+90);
  cir18.attachImage(Cadena);
  mundo.add(cir18);

  FCircle cir19 = new FCircle(30);
  cir19.setPosition(xd, yd+120);
  cir19.attachImage(Cadena);
  mundo.add(cir19);

  FCircle cir20= new FCircle(30);
  cir20.setPosition(xd, yd+150);
  cir20.attachImage(Cadena);
  mundo.add(cir20);

  FCircle cir21= new FCircle(30);
  cir21.setPosition(xd, yd+180);
  cir21.attachImage(Cadena);
  mundo.add(cir21);

  FCircle cir22= new FCircle(30);
  cir22.setPosition(xd, yd+210);
  cir22.attachImage(Cadena);
  mundo.add(cir22);

  FCircle cir23= new FCircle(30);
  cir23.setPosition(xd, yd+240);
  cir23.attachImage(Cadena);
  mundo.add(cir23);

  FCircle cir24= new FCircle(30);
  cir24.setPosition(xd, yd+270);
  cir24.attachImage(Cadena);
  mundo.add(cir24);

  FCircle cir25= new FCircle(30);
  cir25.setPosition(xd, yd+300);
  cir25.attachImage(Cadena);
  mundo.add(cir25);

  FCircle cir26= new FCircle(30);
  cir26.setPosition(xd, yd+330);
  cir26.attachImage(Cadena);
  mundo.add(cir26);

  FCircle cir27= new FCircle(30);
  cir27.setPosition(xd, yd+360);
  cir27.attachImage(Cadena);
  mundo.add(cir27);

  FCircle cir28= new FCircle(30);
  cir28.setPosition(xd, yd+390);
  cir28.attachImage(Cadena);
  mundo.add(cir28);

  FCircle cir29= new FCircle(30);
  cir29.setPosition(xd, yd+420);
  cir29.attachImage(Cadena);
  mundo.add(cir29);

  FCircle cir30= new FCircle(30);
  cir30.setPosition(xd, yd+450);
  cir30.attachImage(Cadena);
  mundo.add(cir30);

  //--------------------------------------
  //Circulos grandes arriba
  //1
  FCircle polea1 = new FCircle(70);
  polea1.setStatic(true);
  polea1.setPosition(388, 76);
  polea1.setGrabbable(false);
  polea1.attachImage(CircInmG);
  mundo.add(polea1);
  //2
  FCircle polea2 = new FCircle(70);
  polea2.setStatic(true);
  polea2.setGrabbable(false);
  polea2.setPosition(660, 76);
  polea2.attachImage(CircInmG);
  mundo.add(polea2);

  //-----------------------------------
  //para cadena
  //junto a plataforma
  FCircle cirIzq0= new FCircle(30);
  cirIzq0.setPosition(614, 646);
  cirIzq0.attachImage(Cadena);
  mundo.add(cirIzq0);

  FCircle cirIzq= new FCircle(30);
  cirIzq.setPosition(614, 676);
  cirIzq.attachImage(Cadena);
  mundo.add(cirIzq);

  FCircle cirDer0= new FCircle(30);
  cirDer0.setPosition(803, 646);
  cirDer0.attachImage(Cadena);
  mundo.add(cirDer0);

  FCircle cirDer= new FCircle(30);
  cirDer.setPosition(803, 676);
  cirDer.attachImage(Cadena);
  mundo.add(cirDer);

  //plataforma
  FBox box1 = new FBox(170, 30);
  box1.setPosition(702, 676);
  box1.attachImage (Ascensor);
  mundo.add(box1);

  //bola de boliche
  FCircle bolaPolea = new FCircle (50);
  //bolaPolea.setPosition(340, 160);
  bolaPolea.setPosition(340, 130);
  bolaPolea.setDensity(30);
  bolaPolea.attachImage (bbolgrand);
  mundo.add(bolaPolea);


  //------------------
  //Uniones
  FDistanceJoint cadenaPol0 = new FDistanceJoint(bolaPolea, cir1);
  cadenaPol0.setLength(30);
  cadenaPol0.setFill(231, 209, 146);
  mundo.add(cadenaPol0);

  FDistanceJoint cadenaPol1 = new FDistanceJoint(cir1, cir2);
  cadenaPol1.setLength(30);
  cadenaPol1.setFill(231, 209, 146);
  mundo.add(cadenaPol1);

  FDistanceJoint cadenaPol2 = new FDistanceJoint(cir2, cir3);
  cadenaPol2.setLength(30);
  cadenaPol2.setFill(231, 209, 146);
  mundo.add(cadenaPol2);

  FDistanceJoint cadenaPol3 = new FDistanceJoint(cir3, cir4);
  cadenaPol3.setLength(30);
  cadenaPol3.setFill(231, 209, 146);
  mundo.add(cadenaPol3);

  FDistanceJoint cadenaPol4 = new FDistanceJoint(cir4, cir5);
  cadenaPol4.setLength(30);
  cadenaPol4.setFill(231, 209, 146);
  mundo.add(cadenaPol4);

  FDistanceJoint cadenaPol5 = new FDistanceJoint(cir5, cir6);
  cadenaPol5.setLength(30);
  cadenaPol5.setFill(231, 209, 146);
  mundo.add(cadenaPol5);

  FDistanceJoint cadenaPol6 = new FDistanceJoint(cir6, cir7);
  cadenaPol6.setLength(30);
  cadenaPol6.setFill(231, 209, 146);
  mundo.add(cadenaPol6);

  FDistanceJoint cadenaPol7 = new FDistanceJoint(cir7, cir8);
  cadenaPol7.setLength(30);
  cadenaPol7.setFill(231, 209, 146);
  //mundo.add(cadenaPol7);

  FDistanceJoint cadenaPol8 = new FDistanceJoint(cir8, cir9);
  cadenaPol8.setLength(30);
  cadenaPol8.setFill(231, 209, 146);
  //mundo.add(cadenaPol8);

  FDistanceJoint cadenaPol9 = new FDistanceJoint(cir9, cir10);
  cadenaPol9.setLength(30);
  cadenaPol9.setFill(231, 209, 146);
  //mundo.add(cadenaPol9);

  FDistanceJoint cadenaPol10 = new FDistanceJoint(cir10, cir11);
  cadenaPol10.setLength(30);
  cadenaPol10.setFill(231, 209, 146);
  //mundo.add(cadenaPol10);
  //----------------------------------------------------------------------------------------------
  FDistanceJoint cadenaPol111 = new FDistanceJoint(cir7, cir9);
  cadenaPol10.setLength(30);
  cadenaPol10.setFill(231, 209, 146);
  mundo.add(cadenaPol111);

  FDistanceJoint cadenaPol112 = new FDistanceJoint(cir9, cir11);
  cadenaPol10.setLength(30);
  cadenaPol10.setFill(231, 209, 146);
  mundo.add(cadenaPol112);
  //----------------------------------------------------------------------------------------------
  FDistanceJoint cadenaPol11 = new FDistanceJoint(cir11, cir12);
  cadenaPol11.setLength(30);
  cadenaPol11.setFill(231, 209, 146);
  mundo.add(cadenaPol11);

  FDistanceJoint cadenaPol12 = new FDistanceJoint(cir12, cir13);
  cadenaPol12.setLength(30);
  cadenaPol12.setFill(231, 209, 146);
  mundo.add(cadenaPol12);

  FDistanceJoint cadenaPol13 = new FDistanceJoint(cir13, cir14);
  cadenaPol13.setLength(30);
  cadenaPol13.setFill(231, 209, 146);
  mundo.add(cadenaPol13);

  FDistanceJoint cadenaPol14 = new FDistanceJoint(cir14, cir15);
  cadenaPol14.setLength(30);
  cadenaPol14.setFill(231, 209, 146);
  mundo.add(cadenaPol14);

  FDistanceJoint cadenaPol15 = new FDistanceJoint(cir15, cir16);
  cadenaPol15.setLength(30);
  cadenaPol15.setFill(231, 209, 146);
  mundo.add(cadenaPol15);

  FDistanceJoint cadenaPol16 = new FDistanceJoint(cir16, cir17);
  cadenaPol16.setLength(30);
  cadenaPol16.setFill(231, 209, 146);
  mundo.add(cadenaPol16);

  FDistanceJoint cadenaPol17 = new FDistanceJoint(cir17, cir18);
  cadenaPol17.setLength(30);
  cadenaPol17.setFill(231, 209, 146);
  mundo.add(cadenaPol17);

  FDistanceJoint cadenaPol18 = new FDistanceJoint(cir18, cir19);
  cadenaPol18.setLength(30);
  cadenaPol18.setFill(231, 209, 146);
  mundo.add(cadenaPol18);

  FDistanceJoint cadenaPol19 = new FDistanceJoint(cir19, cir20);
  cadenaPol19.setLength(30);
  cadenaPol19.setFill(231, 209, 146);
  mundo.add(cadenaPol19);

  FDistanceJoint cadenaPol20 = new FDistanceJoint(cir20, cir21);
  cadenaPol20.setLength(30);
  cadenaPol20.setFill(231, 209, 146);
  mundo.add(cadenaPol20);

  FDistanceJoint cadenaPol21 = new FDistanceJoint(cir21, cir22);
  cadenaPol21.setLength(30);
  cadenaPol21.setFill(231, 209, 146);
  mundo.add(cadenaPol21);

  FDistanceJoint cadenaPol22 = new FDistanceJoint(cir22, cir23);
  cadenaPol22.setLength(30);
  cadenaPol22.setFill(231, 209, 146);
  mundo.add(cadenaPol22);

  FDistanceJoint cadenaPol23 = new FDistanceJoint(cir23, cir24);
  cadenaPol23.setLength(30);
  cadenaPol23.setFill(231, 209, 146);
  mundo.add(cadenaPol23);

  FDistanceJoint cadenaPol24 = new FDistanceJoint(cir24, cir25);
  cadenaPol24.setLength(30);
  cadenaPol24.setFill(231, 209, 146);
  mundo.add(cadenaPol24);

  FDistanceJoint cadenaPol25 = new FDistanceJoint(cir25, cir26);
  cadenaPol25.setLength(30);
  cadenaPol25.setFill(231, 209, 146);
  mundo.add(cadenaPol25);

  FDistanceJoint cadenaPol26 = new FDistanceJoint(cir26, cir27);
  cadenaPol26.setLength(30);
  cadenaPol26.setFill(231, 209, 146);
  mundo.add(cadenaPol26);

  FDistanceJoint cadenaPol27 = new FDistanceJoint(cir27, cir28);
  cadenaPol27.setLength(30);
  cadenaPol27.setFill(231, 209, 146);
  mundo.add(cadenaPol27);

  FDistanceJoint cadenaPol28 = new FDistanceJoint(cir28, cir29);
  cadenaPol28.setLength(30);
  cadenaPol28.setFill(231, 209, 146);
  mundo.add(cadenaPol28);

  FDistanceJoint cadenaPol29 = new FDistanceJoint(cir29, cir30);
  cadenaPol29.setLength(30);
  cadenaPol29.setFill(231, 209, 146);
  mundo.add(cadenaPol29);

  FDistanceJoint cadenaPol30 = new FDistanceJoint(cir30, cirIzq0);
  cadenaPol30.setLength(150);
  cadenaPol30.setFill(231, 209, 146);
  mundo.add(cadenaPol30);

  FDistanceJoint cadenaPol31 = new FDistanceJoint(cirIzq0, cirIzq);
  cadenaPol31.setLength(30);
  cadenaPol31.setFill(231, 209, 146);
  mundo.add(cadenaPol31);

  FDistanceJoint cadenaPol32 = new FDistanceJoint(cirIzq, box1);
  cadenaPol32.setLength(30);
  cadenaPol32.setFill(231, 209, 146);
  mundo.add(cadenaPol32);

  FDistanceJoint cadenaPol33 = new FDistanceJoint(box1, cirDer);
  cadenaPol33.setLength(30);
  cadenaPol33.setFill(231, 209, 146);
  mundo.add(cadenaPol33);

  FDistanceJoint cadenaPol34 = new FDistanceJoint(cirDer, cirDer0);
  cadenaPol34.setLength(30);
  cadenaPol34.setFill(231, 209, 146);
  mundo.add(cadenaPol34);

  FDistanceJoint cadenaPol35 = new FDistanceJoint(cirDer0, cir30);
  cadenaPol35.setLength(150);
  cadenaPol35.setFill(231, 209, 146);
  mundo.add(cadenaPol35);

  //-----------------------------------------------------------------------------------------------------------
  //Boton para reiniciar si no podes seguir jugando
  boton = new Plataforma(60, 60);
  boton.inicializar (1520, 850);
  boton.attachImage(botonReiniciar);
  mundo.add(boton);
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------------

//PARA SACAR LAS PLATAFORMAS
void mousePressed() { //plataforma del hamster
  if (mouseX > 140 - 150/2 && mouseX < 140+150/2
    && mouseY > 145 - 30/2 && mouseY < 145+30/2) {
    mundo.remove(base1);
    pop.play();
    pop.amp(0.2);
  } else { // diagonal resbala
    if (mouseX > 518 - 30/2 && mouseX < 518+30/2
      && mouseY >560 - 30/2 && mouseY < 560+30/2) {
      mundo.remove(base2);
      pop.play();
      pop.amp(0.2);
    } else { // to bola de polea
      if (mouseX > 340 - 150/2 && mouseX < 340+150/2
        && mouseY > 190 - 30/2 && mouseY < 190+30/2) {
        mundo.remove(base3);
        pop.play();
        pop.amp(0.2);
      } else { //donde cae hamster/bola demoledora
        if (mouseX > 1100 - 150/2 && mouseX < 1100+150/2
          && mouseY > 595 - 30/2 && mouseY < 595+30/2) {
          mundo.remove(base4);
          pop.play();
          pop.amp(0.2);
        } else { //to bola de catapulta
          if (mouseX > 1440 - 150/2 && mouseX < 1440+150/2
            && mouseY > 230 - 30/2 && mouseY < 230+30/2) {
            mundo.remove(base6);
            pop.play();
            pop.amp(0.2);
          } else { //(diagonal) ''
            if (mouseX > 1194 - 30/2 && mouseX < 1194+30/2
              && mouseY > 64 - 30/2 && mouseY < 64+30/2) {
              mundo.remove(base7);
              pop.play();
              pop.amp(0.2);
            } else { //(diagonal) /
              if (mouseX > 933 - 30/2 && mouseX < 933+30/2
                && mouseY > 194 - 30/2 && mouseY < 194+30/2) {
                mundo.remove(base8);
                pop.play();
                pop.amp(0.2);
              } else { //to puñete
                if (mouseX > 586 - 20/2 && mouseX < 586+20/2
                  && mouseY > 195 - 60/2 && mouseY < 195+60/2) {
                  mundo.remove(base11);
                  pop.play();
                  pop.amp(0.2);
                } else { //círculo de breaking ball
                  if (mouseX > 897 - 30/2 && mouseX < 897+30/2
                    && mouseY > 390 - 30/2 && mouseY < 390+30/2) {
                    mundo.remove(baseC1);
                    pop.play();
                    pop.amp(0.2);
                  } else { //círculo de diagonal
                    if (mouseX > 163 - 60/2 && mouseX < 163+60/2
                      && mouseY > 538 - 60/2 && mouseY < 538+60/2) {
                      mundo.remove(baseC2);
                      pop.play();
                      pop.amp(0.2);
                    } else { //círculo de diagonal
                      if (mouseX > 1290 - 30/2 && mouseX < 1290+30/2
                        && mouseY > 687 - 30/2 && mouseY < 687+30/2) {
                        mundo.remove(baseC3);
                        pop.play();
                        pop.amp(0.2);
                      } else { //botón de reiniciar
                        if (mouseX > 1520 - 60/2 && mouseX <  1520 + 60/2
                          && mouseY > 850 - 60/2 && mouseY < 850 + 60/2) {
                          perder();
                          ambiente.stop();
                          pop.play();
                          pop.amp(0.2);
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

//----------------------------------------------------------------------------------------
void contactStarted(FContact contact) {

  FBody _cuerpo1 = contact.getBody1();
  FBody _cuerpo2 = contact.getBody2();

  /////////////////////////////SALTAR/////////////////////////////
  if (puntos>2 &&(_cuerpo1.getName() == "hamster" && _cuerpo2.getName() == "platAbajo")
    || (_cuerpo2.getName() == "hamster" && (_cuerpo1.getName() == "platAbajo" ))) {
    boing.play();
    boing.amp(0.7);
  }

  /////////////////////////////SUMAR PUNTOS/////////////////////////////
  //Si puntos es igual a tres, funcion ganar
  if (puntos == 3) {

    //Se para sonido ambiente y perdiste
    ambiente.stop();
    perdiste.stop();

    //empieza sonido ganaste
    ganaste.loop();
    ganaste.amp(0.5);

    ganar();
  }


  if (_cuerpo1.getName() == "hamster" && _cuerpo2.getName() == "semilla") {
    ((Semilla)_cuerpo2).agarrar();
    //punto.play();
  } else if (_cuerpo2.getName() == "hamster" && _cuerpo1.getName() == "semilla") {
    ((Semilla) _cuerpo1).agarrar();
    //punto.play();
  }


  /////////////////////////////PERDER/////////////////////////////
  else if ((_cuerpo1.getName() == "hamster" && _cuerpo2.getName() == "pinchos")
    || (_cuerpo2.getName() == "hamster" && (_cuerpo1.getName() == "pinchos" ))) {
    if (hamster.vivo) {
      //println("colision");

      //Se para sonido ambiente
      ambiente.stop();

      //Sonido ouch
      ouch.play();
      ouch.amp(0.2);

      //empieza sonido trist

      perder();
    }
  }
}

void perder() {
  perdiste.loop();
  perdiste.amp(0.5);
  hamster.morir();
  mundo.remove(hamster);
  estado = "Perdiste";
}


void ganar() {
  hamster.morir();
  mundo.remove(hamster);
  estado = "Ganaste";
}

//------------------------------------------

//para tiempo
void setBegin(int tiempo_) {
  begin = tiempo_;
}

boolean getTermino() {
  return termino;
}

void reciclarVar() {
  time = duracion = 50;
  begin=millis();
  termino=false;
}
