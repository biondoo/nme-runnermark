package aze.display;

import aze.display.TileLayer;
import nme.display.BitmapData;
import nme.display.Tilesheet;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Lib;

using StringTools;

/**
 * Sparrow spritesheet parser (supports trimmed PNGs)
 * compatible with TileLayer.
 * @author Philippe / http://philippe.elsass.me
 */
class SparrowTilesheet extends Tilesheet, implements TilesheetEx
{
	var defs:Array<String>;
	var sizes:Array<Rectangle>;
	var anims:Hash<Array<Int>>;
	#if flash
	var bmps:Array<BitmapData>;
	#end

	public function new(img:BitmapData, xml:String) 
	{
		super(img);
		
		defs = new Array<String>();
		anims = new Hash<Array<Int>>();
		sizes = new Array<Rectangle>();
		#if flash
		bmps = new Array<BitmapData>();
		#end

		var cpt:Int = 0;
		var ins = new Point(0,0);
		
		var x = Xml.parse(xml);
		for (node in x.elements())
			for (texture in node.elements())
			{
				defs.push(texture.get("name"));
				var r = new Rectangle(
					Std.parseInt(texture.get("x")), Std.parseInt(texture.get("y")),
					Std.parseInt(texture.get("width")), Std.parseInt(texture.get("height")));

				var s = if (texture.get("frameX") != null)
						new Rectangle(
							Std.parseInt(texture.get("frameX")), Std.parseInt(texture.get("frameY")),
							Std.parseInt(texture.get("frameWidth")), Std.parseInt(texture.get("frameHeight")));
					else 
						new Rectangle(0,0, r.width, r.height);
				sizes.push(s);
				addTileRect(r, new Point(s.x + s.width / 2, s.y + s.height / 2));
				#if flash
				var bmp = new BitmapData(cast s.width, cast s.height, true, 0);
				ins.x = -s.left;
				ins.y = -s.top;
				bmp.copyPixels(img, r, ins);
				bmps.push(bmp);
				#end
			}
	}

	public function getAnim(name:String):Array<Int>
	{
		if (anims.exists(name))
			return anims.get(name);
		var indices = new Array<Int>();
		for (i in 0...defs.length)
		{
			if (defs[i].startsWith(name)) 
				indices.push(i);
		}
		anims.set(name, indices);
		return indices;
	}

	inline public function getSize(indice:Int):Rectangle
	{
		return sizes[indice];
	}

	#if flash
	inline public function getBitmap(indice:Int):BitmapData
	{
		return bmps[indice];
	}
	#end
}
