package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxAnimation;
import openfl.utils.Dictionary;

class Character extends FlxSprite
{
	public var character:String;
	public var characterPATH:String;
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var animated:Bool = true;
	public var txt:Bool = false;
	public var multipleSpecials:Bool = true;
	public var specials:Array<String>;

	private var beeping:Bool;

	public var curAnim:FlxAnimation;

	var framerate:Int = 24;

	public function new(x:Float = 0, y:Float = 0, char:String)
	{
		super(x, y);
		animOffsets = new Map<String, Array<Dynamic>>();
		antialiasing = true;
		character = char;
		char = "characters/" + char;
		flipX = PlayState.flip;
		characterPATH = char;
		var idle:String = "idle";
		var loopidle:Bool = false;
		var up:String = "up";
		var loopup:Bool = false;
		var down:String = "down";
		var loopdown:Bool = false;
		var left:String = "left";
		var loopleft:Bool = false;
		var right:String = "right";
		var loopright:Bool = false;
		var upmiss:String = "upmiss";
		var loopupmiss:Bool = false;
		var downmiss:String = "downmiss";
		var loopdownmiss:Bool = false;
		var leftmiss:String = "leftmiss";
		var loopleftmiss:Bool = false;
		var rightmiss:String = "rightmiss";
		var looprightmiss:Bool = false;
		var upalt:String = "upalt";
		var loopupalt:Bool = false;
		var downalt:String = "downalt";
		var loopdownalt:Bool = false;
		var leftalt:String = "leftalt";
		var loopleftalt:Bool = false;
		var rightalt:String = "rightalt";
		var looprightalt:Bool = false;
		switch (character)
		{
			case "pico":
				idle = "Pico Idle Dance";
				up = "pico Up note0";
				down = "Pico Down Note0";
				left = "Pico NOTE LEFT0";
				right = "Pico Note Right0";
				upmiss = "pico Up note miss";
				downmiss = "Pico Down Note MISS";
				leftmiss = "Pico NOTE LEFT miss";
				rightmiss = "Pico Note Right Miss";

				addOffset("idle");
				addOffset("up", -29, 27);
				addOffset("right", -68, -7);
				addOffset("left", 65, 9);
				addOffset("down", 200, -70);
				addOffset("upmiss", -19, 67);
				addOffset("rightmiss", -60, 41);
				addOffset("leftmiss", 62, 64);
				addOffset("downmiss", 210, -28);

			case "BOYFRIEND", "bf-car", "bf-christmas":
				idle = "BF idle dance";
				up = "BF NOTE UP0";
				left = "BF NOTE LEFT0";
				right = "BF NOTE RIGHT0";
				down = "BF NOTE DOWN0";
				upmiss = "BF NOTE UP MISS";
				leftmiss = "BF NOTE LEFT MISS";
				rightmiss = "BF NOTE RIGHT MISS";
				downmiss = "BF NOTE DOWN MISS";

				addOffset("idle", -5);
				addOffset("up", -29, 27);
				addOffset("right", -38, -7);
				addOffset("left", 12, -6);
				addOffset("down", -10, -50);
				addOffset("upmiss", -29, 27);
				addOffset("rightmiss", -30, 21);
				addOffset("leftmiss", 12, 24);
				addOffset("downmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset("firstDeath", 37, 11);
				addOffset("deathLoop", 37, 5);
				addOffset("deathConfirm", 37, 69);
				addOffset("scared", -4);

			case "senpai":
				idle = "Senpai Idle";
				up = "SENPAI UP NOTE";
				left = "SENPAI LEFT NOTE";
				right = "SENPAI RIGHT NOTE";
				down = "SENPAI DOWN NOTE";

				addOffset('idle');
				addOffset("up", 5, 37);
				addOffset("right");
				addOffset("left", 40);
				addOffset("down", 14);

				antialiasing = false;

			case "senpai-angry":
				idle = "Angry Senpai Idle";
				up = "Angry Senpai UP NOTE";
				left = "Angry Senpai LEFT NOTE";
				right = "Angry Senpai RIGHT NOTE";
				down = "Angry Senpai DOWN NOTE";

				addOffset('idle');
				addOffset("up", 5, 37);
				addOffset("right");
				addOffset("left", 40);
				addOffset("down", 14);

				antialiasing = false;

			case "bf-holding-gf" /* WOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO WEEK 7 */:
				idle = "BF idle dance";
				up = "BF NOTE UP0";
				left = "BF NOTE LEFT0";
				right = "BF NOTE RIGHT0";
				down = "BF NOTE DOWN0";
				upmiss = "BF NOTE UP MISS";
				leftmiss = "BF NOTE LEFT MISS";
				rightmiss = "BF NOTE RIGHT MISS";
				downmiss = "BF NOTE DOWN MISS";

				addOffset("idle");
				addOffset("up", -29, 10);
				addOffset("down", -10, 10);
				addOffset("left", 12, 7);
				addOffset("right", -41, 23);
				addOffset("upmiss", -29, 10);
				addOffset("downmiss", -10, -10);
				addOffset("leftmiss", 12, 7);
				addOffset("rightmiss", -41, 23);
				addOffset("catch");

			case "spooky kids":
				idle = "spooky dance idle";
				up = "spooky UP NOTE";
				down = "spooky DOWN note";
				left = "note sing left";
				right = "spooky sing right";

				addOffset("idle");
				addOffset("up", -20, 26);
				addOffset("right", -130, -14);
				addOffset("left", 130, -10);
				addOffset("down", -50, -130);

			case "tankman" /* WOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO MORE WEEK 7 */:
				idle = "Tankman Idle Dance";
				up = "Tankman UP note";
				down = "Tankman DOWN note";
				right = "Tankman Right Note";
				left = "Tankman Note Left";

				addOffset("idle");
				addOffset("up", 24, 56);
				addOffset("right", -1, -7);
				addOffset("left", 100, -14);
				addOffset("down", 98, -90);

			case "spirit":
				txt = true;
				idle = "idle spirit_";
				up = "up_";
				right = "right_";
				left = "left_";
				down = "spirit down_";

				addOffset('idle', -220, -280);
				addOffset('up', -220, -240);
				addOffset("right", -220, -280);
				addOffset("left", -200, -280);
				addOffset("down", 170, 110);

				antialiasing = false;

			default:
				animated = false;
				loadGraphic(Paths.image(char));
		}
		if (animated)
		{
			var tex;
			if (txt)
				tex = Paths.getPackerAtlas(char);
			else
				tex = Paths.getSparrowAtlas(char);
			frames = tex;
			if (PlayState.flip)
			{
				var left1:String = left;
				var right1:String = right;
				left = right1;
				right = left1;

				left1 = leftmiss;
				right1 = rightmiss;
				leftmiss = right1;
				rightmiss = left1;

				left1 = leftalt;
				right1 = rightalt;
				leftalt = right1;
				rightalt = left1;
			}
			animation.addByPrefix("idle", idle, framerate, loopidle);
			animation.addByPrefix("up", up, framerate, loopup);
			animation.addByPrefix("down", down, framerate, loopdown);
			animation.addByPrefix("left", left, framerate, loopleft);
			animation.addByPrefix("right", right, framerate, loopright);
			animation.addByPrefix("upmiss", upmiss, framerate, loopupmiss);
			animation.addByPrefix("downmiss", downmiss, framerate, loopdownmiss);
			animation.addByPrefix("leftmiss", leftmiss, framerate, loopleftmiss);
			animation.addByPrefix("rightmiss", rightmiss, framerate, looprightmiss);
			animation.addByPrefix("upalt", upalt, framerate, loopupalt);
			animation.addByPrefix("downalt", downalt, framerate, loopdownalt);
			animation.addByPrefix("leftalt", leftalt, framerate, loopleftalt);
			animation.addByPrefix("rightalt", rightalt, framerate, looprightalt);
			switch (character)
			{
				case "BOYFRIEND", "bf-car", "bf-christmas":
					animation.addByPrefix("hey", "BF HEY!!", framerate, false);
					animation.addByPrefix("firstDeath", "BF dies", framerate, false);
					animation.addByPrefix("deathLoop", "BF Dead Loop", framerate);
					animation.addByPrefix("deathConfirm", "BF Dead confirm", framerate, false);
					animation.addByPrefix("scared", "BF idle shaking", framerate, false);
				case "bf-holding-gf":
					animation.addByPrefix("catch", "BF catches GF", framerate, false);
				case "senpai", "spirit", "senpai-angry":
					setGraphicSize(Std.int(width * 5));
					updateHitbox();
				case "spooky kids":
					animation.addByPrefix("spooky dance", "do da spooky dance!", 60, false);
				case "tankman":
					animation.addByPrefix("ugh", "TANKMAN UGH", framerate, false);
					animation.addByPrefix("pretty good", "PRETTY GOOD tankman", framerate, false);
			}

			playAnim("idle");
		}
	}

	public function SPECIAL()
	{
		if (PlayState.special == "" || SelectStuff.endsWith(PlayState.special, SelectStuff.NOT_WORKING))
			return;
		if ((PlayState.stage == "spooky") && (character == "BOYFRIEND") && (PlayState.special == "scared"))
		{
			PlayState.halloweenBG.animation.play("lightning", true);
			FlxG.sound.play(Paths.soundRandom("thunder_", 1, 2));
		}
		playAnim(PlayState.special);
	}

	public override function update(elapsed:Float)
	{
		curAnim = animation.curAnim;
		super.update(elapsed);
	}

	public function miss(direction:String)
	{
		if (animation.getByName(direction + "miss") != null)
		{
			FlxG.sound.play(Paths.soundRandom("missnote", 1, 3));
		}
	}

	public function beep(direction:String)
	{
		if (SelectStuff.endsWith(direction, SelectStuff.NOT_WORKING))
			return;
		if (SelectStuff.noSounds.exists(character))
		{
			for (sound in SelectStuff.noSounds[character])
				if (sound == direction)
					return;
		}
		if (PlayState.flip)
		{
			if (direction == "left")
				direction = "right";
			else if (direction == "right")
				direction = "left";
		}
		if (PlayState.miss == "miss")
			miss(direction);
		else
			FlxG.sound.play(Paths.sound("characters/" + character + "_" + direction));
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function playAnim(AnimName:String, Force:Bool = true, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
	}
}
