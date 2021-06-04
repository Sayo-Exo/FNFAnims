package;

import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

class UI extends FlxTypedGroup<FlxObject>
{
	var watermarkText:FlxText;

	public function new(watermark:String, watermarkAlpha:Float)
	{
		super();
		watermarkText = new FlxText(0, 0, 0, watermark, 25);
		watermarkText.alpha = watermarkAlpha;
		watermarkText.alignment = LEFT;
		add(watermarkText);
		forEach(function(thing)
		{
			thing.scrollFactor.set(0, 0);
		});
	}

	public function updateStuff(watermark:String, watermarkAlpha:Float)
	{
		watermarkText.text = watermark;
		watermarkText.alpha = watermarkAlpha;
	}

	public function addY(y:Float)
	{
		forEach(function(thing)
		{
			thing.y += y;
		});
	}

	public function addX(x:Float)
	{
		forEach(function(thing)
		{
			thing.x += x;
		});
	}
}
