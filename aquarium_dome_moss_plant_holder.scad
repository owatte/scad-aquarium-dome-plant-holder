/*
File: aquarium_dome_moss_plant_holder.scad

Description:
support pour plantes aquatiques (typiquement des mousses hépatiques) dans aquarium.

Auteur : Olivier Watté

Licence : GNU GPL V3 or above
*/

RAYON = 30;
HAUTEUR  = 25;
EPAISSEUR = 2;
// trous rectangulaires H * L
HOLE_H = 5 ;
HOLE_L = 8;

SIZE_FACTOR =1;

DOME = true;
STOPPER = true;
/*************************************************
* Dôme
*************************************************/
/* créer un dôme */
module create_dome ( rayon ) {
    cubeX = rayon * 2;
    cubeY = rayon * 2;
    cubeZ = rayon;
    difference(){
        sphere(r=rayon);
        translate([-rayon, -rayon, -rayon]) cube([cubeX, cubeY, cubeZ]);
    }
}


/* vider le dôme */
module empty_dome (rayon, epaisseur){
    sub_dome_r = rayon - epaisseur;
    difference(){
        create_dome(rayon);
        sphere(r=sub_dome_r);
    }
}




/* créer une mêche rectangulaire */
module drill_bar(largeur, hauteur, longueur, show=false){
        half_hauteur = hauteur / 2;
        rayon = longueur / 2; 
        //translate([0, -half_hauteur, hauteur]) 
        if (show==true){
            #cube([longueur, hauteur, largeur]);
        } else {
            cube([longueur, hauteur, largeur]);
        }
}




/* percer des trous dans le dôme */
module dome(){

    haut=HOLE_H;
    larg=HOLE_L;
    long=RAYON;

    x_axis = RAYON * 2 * SIZE_FACTOR;
    y_axis = x_axis;
    z_axis = HAUTEUR * SIZE_FACTOR;  

    resize(newsize=[x_axis, y_axis, z_axis], auto=[true, true, false])
    difference() {
        empty_dome(RAYON, EPAISSEUR);        
        //translate(0, 0, EPAISSEUR) drill_bar(haut, larg, long);
            for (i=[1:24])  {
                ang = i * 15;
                larg_sm = (larg / 3) * 2;
                translate([0, 0, EPAISSEUR])       
                rotate([0, 0, ang]) {drill_bar(haut, larg_sm, 200);}
            }
           //rotate([0, 0, 7])
           for (i=[1:24])  {
                ang = i * 15;
                larg_sm = (larg / 3) * 2;
                vert_shift = EPAISSEUR + (2 * haut);
                translate([0, 0, 0])       
                rotate([0, -15, ang]) {drill_bar(haut, larg_sm, 200);}
            }
           for (i=[1:24])  {
               
                ang = i * 15;
                larg_sm = (larg / 3) * 2;
                vert_shift = EPAISSEUR + haut;
                color([1, 0, 0])
                translate([0,0, 0])       
                rotate([0, -28, ang]) {drill_bar(haut, larg_sm, 200);}
            }
            rotate([0, 0, 5])
            for (i=[1:18])  {
                ang = i * 20;
                larg_sm = (larg / 3) * 2;
                vert_shift = EPAISSEUR;
                translate([0,0, 0])       
                rotate([0, -40, ang]) {drill_bar(haut, larg_sm, 200, false);}
            }
            rotate([0, 0, 10])
           for (i=[1:18])  {
                ang = i * 20;
                larg_sm = (larg / 2) ;
                vert_shift = EPAISSEUR;
                translate([0,0, 0])       
                rotate([0, -52, ang]) {drill_bar(haut, larg_sm, 200);}
            }
           for (i=[1:10])  {
                ang = i * 36;
            larg_sm = (larg /  3)*2;
               haut = 4;
                rotate([0, -65, ang]) {drill_bar(haut, larg_sm, 200);}
            }
           for (i=[1:4])  {
            ang = i * 90;
            larg_sm = (larg /  3)*2;
            //echo(larg_sm);
            //echo(ang);       
            rotate([0, -79, ang]) {drill_bar(haut, larg_sm, 200);}
        }  
    }
}



/*************************************************
* Bouchon
*************************************************/
/* créer un bouchon */
module stopper_create(){
    rayon = RAYON - EPAISSEUR;
    linear_extrude (height=EPAISSEUR) circle(rayon); 
}

/* percer des trous dans le bouchon */
module bottom_drill_holes(space){

    for (i=[1:3]){
        shift = (i * space) / 2 - EPAISSEUR;
         translate([shift, 0, -2 ]) {linear_extrude (height=EPAISSEUR+10) circle(3);}
         translate([-shift, 0, -2 ]) {linear_extrude (height=EPAISSEUR+10) circle(3);}
         translate([0, shift, -2 ]) {linear_extrude (height=EPAISSEUR+10) circle(3);}
         translate([0, -shift, -2 ]) {linear_extrude (height=EPAISSEUR+10) circle(3);}
    }
    
    for (i=[0:3]){
        shift = RAYON /3 ;
        translate([shift, -shift, -2]) {linear_extrude (height=EPAISSEUR+10) circle(3);}
        translate([-shift, -shift, -2]) {linear_extrude (height=EPAISSEUR+10) circle(3);}
        translate([shift, shift, -2]) {linear_extrude (height=EPAISSEUR+10) circle(3);}
        translate([-shift, shift, -2]) {linear_extrude (height=EPAISSEUR+10) circle(3);}
    }    

}


/* crée le bouchon */
module stopper(){
space = RAYON / 2;
    difference(){
        stopper_create();
        bottom_drill_holes(space);     
    }
}


/******************************************
* object
******************************************/
if (DOME==true)
    dome();
if (STOPPER==true)
    stopper();
