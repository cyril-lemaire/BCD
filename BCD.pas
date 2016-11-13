program BCD;    //  Devoir Maison N�1 de Programmation Pascal :
                //      Gestion d'un afficheur 7 segments.
                
uses Crt, DOS;  // On inclus le package Crt contenant GotoXY et ClrScr
                // (pour l'affichage), DOS contient GetTime pour afficher
                // l'heure.


(*  Les conversions des chiffres d�cimaux en nombres binaires � 4 digits seront
    des BinaryNumber (de simples tableaux de 4 bool�ens).
    
    Un afficheur sept segments est un ensemble de 7 bool�ens nomm�s 'a' � 'g'.
    On stockera ces valeurs dans un SevenSegmentDisplay.
*)
Type
    BinaryNumber = Array [0..3] of Boolean;
    SevenSegmentDisplay = Array['a'..'g'] of Boolean;
    
Const   // Taille de l'�cran (utilis� par les fonctions d'affichage via GotoXY).
    screenWidth = 80;
    screenHeight = 25;


// Partie 1 :

(*  Description de convertDigitToBinary :
    digit :     Param�tre entr�e, contient un digit d�cimal (0 � 9) � convertir
        en nombre bool�en.
    retour :    Un BinaryNumber contenant la valeur de digit. La case 0
        contient les unit�s et la case 3 contient le facteur de 2^3.
*)
Function convertDigitToBinary(digit : Integer) : BinaryNumber;
var
    i : Integer;
    result : BinaryNumber;
Begin   // D�but convertDigitToBinary
    for i:=0 to 3 do    // On sait d'avance que l'on stockera la division sur 4
    Begin               // bool�ens, quitte � stocker [0,0,0,1].
        result[i] := (digit MOD 2 = 1); // result[i] prend la valeur True si
        digit := digit DIV 2;           // digit MOD 2 vaut 1, Faux sinon.
    End;
    convertDigitToBinary := result;     // Et on retourne le r�sultat.
End;    // Fin convertDigitToBinary.
//------------------------------------------------------------------------------

// Fin de la Partie 1.##########################################################


// Partie 2 :

(*  Description de isSegmentLit :
    segment :   Le nom du segment � analyser (de a � g).
    nBool :     L'�criture en binaire quatre bits d'un chiffre d�cimal (0 � 9).
    retour:     Le segment doit-il �tre allum� ?
    
    Note :  Version 1 = D�codeur vrai, en cas d'entr�e fausse (nBool = 10 � 16)
        la sortie sera syst�matiquement fausse (mode Debug).
            Version 2 = D�codeur partiel, en cas d'entr�e fausse la sortie est
        inconnue, mais l'ex�cution est l�g�rement plus rapide (mode Release).
*)
{<!--
Function isSegmentLit(segment : Char; nBool : BinaryNumber) : Boolean;  // Version 1, mode Debug
Begin   // D�but de isSegmentLit.

    Case segment of
    'a' :
        isSegmentLit := ((Not nBool[3] and nBool[1]) or (Not nBool[3] and nBool[2] and nBool[0]) or (Not nBool[2] and Not nBool[1] and Not nBool[0]) or (nBool[3] and Not nBool[2] and Not nBool[1]));
    'b' :
        isSegmentLit := ((not nBool[3] and Not nBool[2]) or ( Not nBool[2] and Not nBool[1]) or (Not nBool[3] and nBool[1] and nBool[0]) or (Not nBool[3] and Not nBool[1] and Not nBool[0]));
    'c' :
        isSegmentLit := ((Not nBool[3] and nBool[2]) or (Not nBool[3] and nBool[0]) or (Not nBool[2] and Not nBool[1]));
    'd' :
        isSegmentLit := ((Not nBool[2] and Not nBool[1] and Not nBool[0]) or (nBool[3] and Not nBool[2] and Not nBool[1]) or (Not nBool[3] and Not nBool[2]and nBool[1]) or (Not nBool[3] and nBool[1] and Not nBool[0]) or (Not nBool[3] and nBool[2] and Not nBool[1] and nBool[0]));
    'e' :
        isSegmentLit := ((Not nBool[2] and Not nBool[1] and Not nBool[0]) or (Not nBool[3] and nBool[1] and Not nBool[0])) ;
    'f' :
        isSegmentLit := ((Not nBool[3] and Not nBool[1] and Not nBool[0]) or (Not nBool[3] and nBool[2]and Not nBool[1]) or(nBool[3] and Not nBool[2] and Not nBool[1]) or (Not nBool[3] and nBool[2] and Not nBool[0]));
    'g' :
        isSegmentLit := ((Not nBool[3] and nBool[2] and Not nBool[1]) or (nBool[3] and Not nBool[2] and Not nBool[1]) or (Not nBool[3] and Not nBool[2] and nBool[1]) or (Not nBool[3] and nBool[1] and Not nBool[0]));
    End;    // Fin de Case of.
End;    // Fin de isSegmentLit.
//------------------------------------------------------------------------------
--!>}

Function isSegmentLit(segment : Char; nBool : BinaryNumber) : Boolean;  // Version 2, mode Release
Begin   // D�but de isSegmentLit.
    Case segment of
    'a' :
        isSegmentLit := (nBool[3] or nBool[1] or (Not nBool[2] and Not nBool[0]) or (nBool[2] and nBool[0]));
    'b' :
        isSegmentLit := ((Not nBool[1] and Not nBool[0]) or (nBool[1] and nBool[0]) or Not nBool[2]);
    'c' :
        isSegmentLit := (Not nBool[1] or nBool[0] or nBool[2]);
    'd' :
        isSegmentLit := (nBool[3] or (Not nBool[2] and nBool[1]) or (Not nBool[2] and Not nBool[0]) or (nBool[2] and Not nBool[1] and nBool[0]) or (nBool[1] and Not nBool[0]));
    'e' :
        isSegmentLit := ((Not nBool[2] and Not nBool[0]) or (nBool[1] and Not nBool[0]));
    'f' :
        isSegmentLit := (nBool[3] or (Not nBool[1] and Not nBool[0]) or (nBool[2] and Not nBool[1]) or (nBool[2] and Not nBool[0]));
    'g' :
        isSegmentLit := (nBool[3] or (nBool[2] and Not nBool[1]) or (Not nBool[2] and nBool[1]) or (nBool[1] and Not nBool[0]));
    End;    // Fin de Case.
End;   // Fin de isSegmentLit.
//------------------------------------------------------------------------------

// Fin de la Partie 2. #########################################################


// Partie 3 :

(*  Description de lineWidth:
    length :    La longueur de la ligne.
    retour :    La largeur de la ligne.
*)
Function lineWidth(length : Integer) : Integer;
Begin
    lineWidth := 1 + length DIV 6;  // Les lignes prennent 1 de largeur
    // tous les 6 de longueur ; longueur [1,5] -> largeur = 1,
End;// longueur [6,11] -> largeur = 2, longueur [12,17] -> largeur = 3, etc...
//------------------------------------------------------------------------------


(*  Description de readSegmentLength :
    maxDigitWidth : La largeur maximale du chiffre dont on saisit la longueur
        des segments.
    retour :        La longueur de segment choisie.
    Lit au clavier une taille de segment de mani�re s�curis�e. Elle doit �tre un
    nombre positif non nul tel que la largeur d'un caract�re ne d�passe pas
    maxDigitWidth.
*)
Function readSegmentLength(maxDigitWidth : Integer) : Integer;
Var
    dataEntry : String[3];
    conversionError : Integer;  // Vaudra 0 si la saisie est bien un nombre.
    segmentWidth : Integer;
Begin   // D�but readSegmentLength
    repeat
        Write('Veuillez entrer la longueur des segments a afficher : ');
        Readln(dataEntry);
        Val(dataEntry, readSegmentLength, conversionError);
        segmentWidth := lineWidth(readSegmentLength);
        // Si le segment est  trop gros, chiffre > maxDigitWidth en largeur.
        if(readSegmentLength + 2*segmentWidth > maxDigitWidth) then
            WriteLn('Erreur ! La largeur d''un chiffre ne peut exceder ',
                    maxDigitWidth, ' !');      // Alors c'est pas bon ! ;)
    // Recommencer tant que n n'est pas valide.
    until((conversionError = 0) and (readSegmentLength >= 1)
          and ((readSegmentLength + 2*segmentWidth) < maxDigitWidth));
End;    // Fin readSegmentLength.
//------------------------------------------------------------------------------


(*  Description de readPrintChar :
    retour : Le caract�re d'affichage choisi.
    Lit au clavier un caract�re (qui ne soit pas une s�quence d'�chappement).
*)
Function readPrintChar() : Char;
Begin   // D�but readPrintChar
    repeat                                  // Saisie du caract�re d'affichage.
        ReadLn(readPrintChar);          // Aucune valeur interdite, � part le
    until(readPrintChar <> #13);    // carriage return (obtenu si l'on clique
End;    // Fin readPrintChar.   // sur Entr�e sans avoir saisi de caract�re).
//------------------------------------------------------------------------------


(*  Description de displaySegments :
    display :       L'afficheur sept digits � afficher (structure de 7 bool�ens
        num�rot�s de 'a' � 'g').
    segLength :     La taille des segments de l'afficheur.
    displayChar :   Le symbole � imprimer sur les zones allum�es de l'afficheur.
        cas sp�cial : ' ' pour Debug, affiche le nom du segment (a � g).
    x0, y0 :        La position du coin en haut � gauche de l'afficheur.
*)
Procedure displaySegments(display : SevenSegmentDisplay; segLength : Integer;
                            displayChar : Char; x0, y0 : Integer);
var
    seg : Char;
    x, y, l, w : Integer;   // x abscisse, y ordonn�e : [1,1] en haut � gauche.
    segWidth, deltaL : Integer;     // On fera des segments de largeur variable.
    // Les segments ont des bords pointus, deltaL g�re le changement de longueur
    // des segments selon la couche d'�paisseur en cours.
    isSegmentHorizontal : Boolean;
Begin   // D�but displaySegments
    segWidth := lineWidth(segLength);
    for seg := 'a' to 'g' do    // Pour chaque segment :
    Begin
        Case seg of     // Initialisation du segment :
        // Les segments ont �t� list�s dans l'ordre classique de lecture.
        'a' : Begin     // Position initiale (d�but du segment) : On pose le
                    // d�but d'un segment � son extr�mit� haute ou gauche.
                x := segWidth;      // Attention : Origine = [1,1] (pas [0,0]) !
                y := 0;             // On commencera donc le segment � [x+1,y+1]
                isSegmentHorizontal := True;    // dans l'affichage
            End;
        'f' : Begin
                x := 0;
                y := segWidth;
                isSegmentHorizontal := False;
            End;
        'b' : Begin
                x := segWidth+segLength;
                y := segWidth;
                isSegmentHorizontal := False;
            End;
        'g' : Begin
                x := segWidth;
                y := segWidth+segLength;
                isSegmentHorizontal := True;
            End;
        'e' : Begin
                x := 0;
                y := 2*segWidth+segLength;
                isSegmentHorizontal := False;
            End;
        'c' : Begin
                x := segWidth+segLength;
                y := 2*segWidth+segLength;
                isSegmentHorizontal := False;
            End;
        'd' : Begin
                x := segWidth;
                y := 2*segWidth+2*segLength;
                isSegmentHorizontal := True;
            End;
        End;    // Fin du Case of.
        // Afficher le segment :
        if(display[seg]) then   // Si le segment est allum� alors on lance la
        Begin                   // proc�dure d'affichage.
            deltaL := 0;    // On commence avec un d�calage de 0.

            // On affiche chaque ligne du segment.
            for w:= 0 to segWidth-1 do
            Begin
                // On affiche la longueur de segment pour la couche en cours.
                for l := -deltaL to (segLength-1)+deltaL do
                Begin
                    if(isSegmentHorizontal) then
                        GotoXY(x0+x+l,y0+y+w)   // Si le segment est horizontal
                    else                // on avance sur l'axe des x, sinon
                        GotoXY(x0+x+w, y0+y+l); // on avance sur l'axe des y.
                    if(displayChar <> ' ') then // Cas g�n�ral, correspond
                        Write(displayChar)  // donc � la v�rification du test.
                    else                    // Cas sp�cial, si displayChar = ' '
                        Write(seg);         // chaque segment affiche son nom
                                            // ['a'..'g] (permet d'indentifier
                End;                            // tout segment mal positionn�)

                // deltaL s'incr�mente jusqu'� segWidth/2 puis redescend � 0.
                if(w+1 < (segWidth+1) DIV 2) then
                    deltaL := deltaL+1
                else if (w+1 > segWidth DIV 2) then // Et surtout pas else, pour
                    deltaL := deltaL-1;         // g�rer les largeurs paires.
            End;        // On r�p�te l'op�ration pour la ligne suivante.
        End;    // Fin du if(display[seg])
    End;    // Fin du for seg.
    // On positionne le curseur � la ligne :
    GotoXY(1, 4*segWidth+2*segLength+y0);

End;    // Fin displaySegments.
//------------------------------------------------------------------------------

// Fin de la Partie 3. #########################################################


(*  Description de DisplaySingleDigit:
    1 - Demande la saisie d'un chiffre (0 � 9).
    2 - Affiche la traduction du chiffre saisi en binaire 4 bits.
    3 - Affiche l'�tat des segments de l'afficheur 7 segments pour le chiffre
        saisi.
    4 - Demande � l'utilisateur de saisir une taille et un caract�re d'affichage
        puis affiche le chiffre saisi dans la console.
*)
Procedure displaySingleDigit();
var
    dataEntry : String[2];
    n, i, segmentLength : Integer;
    nBool : BinaryNumber;
    printChar, c : Char;
    segments : SevenSegmentDisplay;

Begin   // D�but DisplaySingleDigit
    // Partie 1 : Affichage d'un chiffre en nombre binaire � 4 bits.
    n := -1;    // On initialise n � une valeur invalide.
    repeat      // Saisie s�curis�e d'un chiffre :
        dataEntry[2] := char(0);    // dataEntry[2] identifie les saisies de
        Write('Veuillez entrer un chiffre : ');     // plusieurs caract�res.
        Readln(dataEntry);
        if(dataEntry[2] = char(0)) then // Si la saisie ne fait qu'un caract�re
            n := ord(dataEntry[1]) - ord('0');  // alors n:=integer(saisie).
    until((n < 10) and (n>=0)); // Recommencer tant que n n'est pas un chiffre.
    
    nBool := convertDigitToBinary(n);
    Write('La conversion en binaire du chiffre ', n, ' est ');
    for i := 3 downto 0 do  // La case 0 contient les unit�s, il faut donc
    Begin                   // l'�crire en dernier.
        if(nBool[i]) then
            Write('1')
        Else
            Write('0');
    End;
    WriteLn(' !');
    // Fin de la Partie 1.

    // Partie 2 : Affichage de la valeur de chaque segment en fonction de n.
    (*  On rappelle les correspondances nom/segment :
                                     a
                                    ----
                                 f |    | b
                                   | g  |
                                    ----
                                 e |    | c
                                   |    |
                                    ----
                                     d
    *)
    WriteLn('Etat des segments : (True = Allume, False = Eteint)');
    for c := 'a' to 'g' do  // c repr�sente les segments de l'afficheur (a � g).
    Begin           // On affiche l'�tat des segments de l'afficheur 7 segments.
        segments[c] := isSegmentLit(c, nBool);
        WriteLn('segment ', c, ': ', segments[c]);
    End;
    // Fin de la partie 2.
    
    // Partie 3 : Affichage du digit sous forme d'afficheur 7 segments.
    // Saisie de la longueur de segment, taille max d'un chiffre = screenWidth.
    segmentLength := readSegmentLength(screenWidth);
    Write('Veuillez entrer le caractere d affichage : ');
    printChar := readPrintChar();           // Saisie du caract�re d'affichage.
    ClrScr();   // On commence par effacer l'�cran.
    // On affiche le chiffre selon les param�tres saisis.
    displaySegments(segments, segmentLength, printChar, 1, 1);
    // Fin de la Partie 3.
End;    // Fin DisplaySingleDigit.
//------------------------------------------------------------------------------


// Partie Fun. #################################################################

(*  Description de displayMultipleSegments :
    n :             Le nombre � afficher (en cha�ne de caract�res). La cha�ne de
        caract�re autorise les grands nombres et les nombres commen�ant par 0.
    segLength :     La taille des segments de l'afficheur.
    displayChar :   Le symbole � imprimer sur les zones allum�es de l'afficheur.
        cas sp�cial : ' ' pour Debug, affiche le nom du segment ('a' � 'g').
    x0, y0 :        La position du coin en haut � gauche de l'afficheur.
*)
Procedure DisplayMultipleSegments(n : String; segLength : Integer;
                                  displayChar : Char; x, y : Integer);
Var
    i : Integer;
    c : Char;
    nBool : BinaryNumber;
    display : SevenSegmentDisplay;
    segWidth : Integer;
Begin   // D�but DisplayMultipleSegments
    segWidth := lineWidth(segLength);
    for i:=1 to length(n) do  // Boucle d'affichage du nombre n.
    Begin
        // On transforme le i�me caract�re de n en chiffre d�cimal cod� binaire.
        nBool := convertDigitToBinary(ord(n[i]));
        for c := 'a' to 'g' do          // On calcule les segments � afficher
            display[c] := isSegmentLit(c, nBool);       // pour ce chiffre.
        displaySegments(display, segLength, displayChar,
                        x, y);
        // On calcule la position d'affichage du caract�re suivant, en laissant
        x := x + segLength + 3*segWidth;        // un espace de segWidth.
        // Si le prochain caract�re d�borde de l'�cran
        if(x + 2*segWidth + segLength > 80) then    // On passe � la ligne
        Begin                                       // suivante.
            x := 1;
            y := y + 2*segLength + 5*segWidth;      // On laise un espace
        End;                                        // vertical de 2* segWidth.
    End;    // Fin pour.
    GotoXY(1, y + 2*segLength + 4*segWidth);    // On revient � la ligne.
End;    // Fin DisplayMultipleSegments.
//------------------------------------------------------------------------------


(*  Description de DisplayManyDigits :
    1 - Demande la saisie d'un nombre (moins de 255 caract�res).
    2 - Demande � l'utilisateur de saisir une taille et un caract�re d'affichage
        puis affiche le nombre saisi dans la console.
        Note : La proc�dure doit g�rer elle-m�me l'espacement des caract�res
        et les �ventuels retours � la ligne.
        
    TODO : Eviter le bug � l'ex�cution 'Ranges overrun' pour les grand nombres.
*)
Procedure DisplayNumber();
Var
    i : LongInt;
    segLength : Integer;
    conversionError : Integer;  // Sert � v�rifier si n est bien un nombre.
    printChar : Char;
    n : String;             // N contient le nombre � afficher.
    
Begin   // D�but DisplayNumber
    repeat  // On demande la saisie du nombre � afficher.
        Write('Veuillez entrer un nombre : ');
        Readln(n);
        Val(n, i, conversionError); // On verifie que l'entr�e est un entier.
    until(conversionError = 0); // Recommencer tant que n n'est pas un entier.
    // Saisie de la longueur des segments.
    segLength := readSegmentLength(screenWidth);
    Write('Veuillez entrer le caractere d affichage : ');
    printChar := readPrintChar();       // Saisie du caract�re d'affichage.
    ClrScr();   // On commence par effacer l'�cran.
    DisplayMultipleSegments(n, segLength, printChar, 1, 1);
    GotoXY(1, WhereY + 1);    // On revient � la ligne.
End;    // Fin DisplayNumber.
//------------------------------------------------------------------------------


(*  Description de DisplayTime :
    Affiche l'heure � l'�cran.
    Fait tourner l'heure tant qu'elle est affich�e.
    TODO : Lire le clavier sans mettre en pause pour pouvoir quitter
    (�v�nement ? Lecture du buffer ?..), et mettre en place un buffer pour
    emp�cher l'affichage de saccader (�a ne para�t pas possible avec le
    fonctionnement actuel de DisplaySegments).
*)
Procedure DisplayTime();
Var
    time : Array[0..3] of Integer;
    i, j, segLength, segWidth, charWidth, charHeight, refreshDelay : Integer;
    displayChar : Char;
    tmpStr : String;
Begin   // D�but DisplayTime
    // Saisie de la longueur des segments (au del� de 16 de largeur, les
    // chiffres d�passent de la console).
    segLength := readSegmentLength(16);
    Write('Veuillez entrer le caractere d affichage : ');
    displayChar := readPrintChar();
    Write('Veuillez entrer le temps d''attente entre les rafraichissement : ');
    WriteLn('(temps en centiemes de secondes)');
    ReadLn(refreshDelay);
    segWidth := lineWidth(segLength);
    charWidth := segLength+3*segWidth;      // prend compte de l'espace entre
    charHeight := 2*segLength+4*segWidth;   // les chiffres (segWidth).
    repeat
        GetTime(time[0], time[1], time[2], time[3]); // On r�cup�re l'heure.
        ClrScr();   // On efface l'�cran avant l'affichage.
        for i := 0 to 3 do      // On affiche l'heure. (H:min'\n'sec:sec100)
        Begin
            str(time[i], tmpStr);   // tmpStr prend la valeur de time[i]
            if(time[i] < 10) then       // Si time[i] ne fait qu'un digit, on
                tmpStr := '0'+tmpStr;   // rajoute un z�ro avant � l'affichage.
            DisplayMultipleSegments(tmpStr, segLength, displayChar,
                screenWidth DIV 2 - (2*charWidth+segWidth) +
                (i MOD 2)*(2*charWidth + 3*segWidth), 1 + (i DIV 2)*charHeight);
        End;
        if((time[3] < 25) or (time[3] > 75)) then   // Si on est au changement
        Begin       // de demi-seconde on affiche les ':' de l'horloge.
            for j:=0 to 1 do
            Begin
                GotoXY(40, charHeight DIV 2 + j*charHeight -(1+segWidth DIV 2));
                Write(char(219));           // Le 219�me caract�re ASCII est le
                GotoXY(40, charHeight DIV 2 + j*charHeight+1+(segWidth-1)DIV 2);
                Write(char(219));           // caract�re plein.
            End;
        End;
        GotoXY(1,1);
        Delay(10*refreshDelay);     // On attend (temps en ms).
    until False;    // Boucle infinie. (CTRL+C pour terminer).
End;    // Fin DisplayTime.
//------------------------------------------------------------------------------


(*  Description de Quit :
    1 - Affiche des jolis caract�res random dans le fond.
    2 - Affiche le message exitMessage au milieu de la console, puis attend une
        saisie pour quitter le programme.
*)
procedure Quit();
Const
    exitText = 'Au revoir et a bientot !';
Var
    i : Integer;
Begin
    for i:= 1 to 100 do
    Begin
        // On va � un position al�atoire sur l'�cran.
        GotoXY(random(screenWidth), random(screenHeight));
        // On affiche un des premiers caract�res ASCII choisi al�atoirement.
        Write(char(random(15)+1));
    End;
    // Enfin on affiche le message d'adieu.
    GotoXY((screenWidth-length(exitText)) DIV 2, screenHeight DIV 2);
    Write(exitText);
    // On revient ensuite en bas de la page pour la saisie emp�chant la
    GotoXY(1,screenHeight);         // fermeture brusque du programme.
    Write('Appuyez sur Entree pour quitter...');
    ReadLn; // On attend une entr�e inutile pour emp�cher la fin du programme.
    Halt(0);    // Fin du programme, aucune erreur � d�clarer.
End;
//------------------------------------------------------------------------------

// Fin de la Partie Fun. #######################################################


// Programme principal :
const
// Pour modifier les options, entrer ici le nombre total d'options et le texte
// associ� � chaque option, puis saisir la proc�dure les d�finissant en fin du
// programme principal.
    nbOfOptions = 4;    // Nombre total d'options du menu principal.
    optionText : Array[1..nbOfOptions] of String = (        // Texte associ� �
        '1 : Afficher un chiffre.',                         // chaque option.
        '2 : Afficher un nombre.',
        '3 : Afficher l''heure.',
        '4 : Quitter.'
        // Merci de ne pas d�passer 76 caract�res.
    );
    menuText = 'Menu';  // Ces textes peuvent �tre chang�s simplement en les
    inputText = 'Saisir choix : ';  // modifiant ici.
    // Ces constantes contiennent les caract�res d'affichage du cadre du menu.
    topLeftCorner = char(201);
    topRightCorner = char(187);
    botLeftCorner = char(200);
    botRightCorner = char(188);
    HorizontalBar = char(205);
    VerticalBar = char(186);
var
    i, option, largestOptionLength : Integer;
    choice : String[4]; // On d�finit choice comme une cha�ne de caract�res pour
                        // g�rer les mauvaises saises non num�riques.
    choiceVal,conversionError : Integer;    // Conversion en entier de choice.
Begin   // D�but Programme Principal
    randomize();    // On initialise la fonction random.
    repeat      // Boucle principale du menu (mal indent�e).
        repeat  // Affichage du menu et saisie du choix (+ClrScr).
            largestOptionLength := 0;
            ClrScr();
            for option:=1 to nbOfOptions do
            Begin   // On affiche les diff�rentes options.
                // La plus grande ligne d�terminera la largeur du cadre.
                if (length(optionText[option]) > largestOptionLength) then
                    largestOptionLength := length(optionText[option]);
                GotoXY((screenWidth - length(optionText[option])) DIV 2,
                       (screenHeight - nbOfOptions) DIV 2 + option);
                Write(optionText[option]);  // On affiche l'option en cours.
            End;
            // Titre du Menu :
            GotoXY((screenWidth - length(menuText)) DIV 2,
                   (screenHeight - nbOfOptions) DIV 2 - 2);
            Write(menuText);
            // On affiche le cadre du menu :
                // 1�re ligne.
            GotoXY((screenWidth - largestOptionLength - 4) DIV 2,   // On va en
                   (screenHeight - nbOfOptions - 2) DIV 2);     // haut � gauche.
            Write(topLeftCorner);
            for i := 1 to largestOptionLength+2 do
                Write(HorizontalBar);
            Write(topRightCorner);
                // lignes 2 � nbofOptions+4-1.
            for i:=1 to nbofOptions+2 do
            Begin
                // On affiche les lignes verticales du cadre.
                GotoXY((screenWidth - largestOptionLength - 4) DIV 2,
                       (screenHeight - nbOfOptions - 2) DIV 2 + i);
                Write(VerticalBar);
                GotoXY((screenWidth + largestOptionLength + 2) DIV 2,
                       (screenHeight - nbOfOptions - 2) DIV 2 + i);
                Write(VerticalBar);
            End;
                // Derni�re ligne (nbOfOptions+4).
            GotoXY((screenWidth - largestOptionLength - 4) DIV 2,   // On va en
                   (screenHeight - nbOfOptions) DIV 2 + i);     // bas � gauche.
            Write(botLeftCorner);
            for i := 1 to largestOptionLength+2 do
                Write(HorizontalBar);
            Write(botRightCorner);
            // Fin de l'affichage du cadre
            // Affichage de la ligne de saisie
            GotoXY((screenWidth - length(inputText)) DIV 2,
                   (screenHeight - nbOfOptions) DIV 2 + nbOfOptions + 3);
            Write(inputText);
            ReadLn(choice);
            Val(choice, choiceVal, conversionError);
            ClrScr();
        // On recommence jusqu'� obtenir une saisie correcte de l'utilisateur
        // (soit un chiffre entre 1 et nbOfOptions).
        until ((conversionError=0) and (choiceVal>0) and
               (choiceVal<=nbOfOptions));
        // Lancement du programme choisi :
        case choiceVal of
//!\\   Entrer ici le code des diff�rentes options :
            1 :   DisplaySingleDigit(); // Afficher un chiffre.
            2 :   DisplayNumber();      // Afficher un nombre.
            3 :   DisplayTime();        // Afficher l'heure.
            4 :   Quit();               // Quitter.
        End;    // Fin Case choiceVal of .
        Write('Appuyez sur Entree pour revenir au menu...');
        ReadLn; // On attend une entr�e inutile pour emp�cher la fin du programme.
until false;    // On boucle � l'infini tant que l'utilisateur n'a pas
                // s�lectionn� l'option 'Quitter'.
End.    // Fin Programme Principal.
//______________________________________________________________________________
