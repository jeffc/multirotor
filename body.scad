use <pins.scad>
use <beaglebone_black.scad>

$fn = 32;

thickness = 9;
size = 300.0;
bolt_rad = 5;

arm_len = 500;
arm_wid = size/8;

landing_size = 100;

explode=3;
explode=0;

module plate()
{
  translate([0,0,thickness/2])
  difference()
  {
    union()
    {
      cube([size, size/4, thickness], center=true);
      cube([size/4, size, thickness], center=true);
      translate([0,0,-thickness/2])
      cylinder(r = size/3, h=thickness);
    }

    for(i = [0,90,180,270])
    {
      rotate([0,0,i])
      {
        translate([-size/2 + (0.05*size), size/12, -thickness])
          cylinder(r=bolt_rad, h=thickness*2);
        translate([-size/2 + (0.05*size), -size/12, -thickness])
          cylinder(r=bolt_rad, h=thickness*2);
        translate([-size/2 + (0.10*size), 0, -thickness])
          cylinder(r=bolt_rad, h=thickness*2);
      }
    }
  }
}


module bottom_plate()
{
  union()
  {
    plate();
    scale([1,1,0.5])
    for(i = [0:36:360])
    {
      rotate([0,0,i])
      translate([-size/4,0,-landing_size*0.5 + thickness])
      rotate([90,0,0])
      {
        difference()
        {
          cylinder(d=landing_size, h=thickness * 2);
          translate([landing_size * 0.1, 0, -thickness * 2])
          cylinder(d=landing_size, h=thickness * 5);
        }
      }
    }

   /* 
    translate([0,0,20])
    //Beaglebone Mount
    translate([-40,-30,10])
    {
      scale([1,1,2])
      boardNegative();
    }
    */
  }
}

module top_plate()
{
  difference()
  {
    plate();
    translate([0,0,-thickness/2])
    cylinder(r=size/4, h=2*thickness);
  }
}
module arm()
{
  translate([-arm_len/2, 0,  arm_wid/2])
  difference()
  {
    union()
    {
      cube([arm_len,arm_wid, arm_wid], center=true);
      translate([arm_len/2-size/4, -size/8,  -arm_wid/2])
      cube([size/4, size/4, arm_wid]);
    }
    cube([arm_len * 1.05, arm_wid * 0.65, arm_wid * 0.65], center=true);

    translate([arm_len/2, 0,  -arm_wid/2])
    translate([size/4,0,0])
    {
      translate([-size/2 + (0.05*size), size/12, -arm_wid/2])
        cylinder(r=bolt_rad, h=arm_wid*2);
      translate([-size/2 + (0.05*size), -size/12, -arm_wid/2])
        cylinder(r=bolt_rad, h=arm_wid*2);
      translate([-size/2 + (0.10*size), 0, -arm_wid/2])
        cylinder(r=bolt_rad, h=arm_wid*2);
    }
  }
}




bottom_plate();
//translate([-40,-30,10])
//beagleboneblack();
for(i = [0,90,180,270])
{
  rotate([0,0,i])
  translate([-size/4 - 2*explode,0,thickness + explode]) arm();
}
translate([0,0,arm_wid + thickness + 2 * explode]) top_plate();
