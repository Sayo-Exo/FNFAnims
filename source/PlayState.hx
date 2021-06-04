package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import openfl.utils.Dictionary;

class PlayState extends FlxState
{
	public static var HaxeDebuggerDocs:String = "https://haxeflixel.com/documentation/debugger/";

	public static var bf:String = "BOYFRIEND";
	public static var stage:String = "menuBG";
	public static var bgm:String = "none";
	public static var special:String = "";
	public static var flip:Bool = false;
	public static var debuggerMessage:Bool = false;
	public static var watermark:String = "";
	public static var watermarkAlpha:Float = 0.5;

	public static var bpmMaps:Dictionary<String, Int> = new Dictionary<String, Int>();

	var musicVolOffset:Float = 0.3;

	public static var miss:String = "";

	var zoom:Float = 1.05;

	private var camFollow:FlxObject;

	private static var boyfriend:Character;

	private var UI:UI;

	public static var halloweenBG:FlxSprite;

	public override function create()
	{
		UI = new UI(watermark, watermarkAlpha);

		super.create();
		FlxG.mouse.visible = false;
		debugStuff();

		if (!SelectStuff.characterSpecials.exists(bf))
			special = "";
		var stagePATH = "bg/" + stage;
		boyfriend = new Character(770, 450, bf);
		switch (stage)
		{
			case "spooky":
				var hallowTex = Paths.getSparrowAtlas(stagePATH + '/halloween_bg');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				UI.addY(30);
				UI.addX(30);

				switch (bf)
				{
					case "spooky kids", "tankman":
						boyfriend.y -= 150;
				}

			case "stage":
				zoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image(stagePATH + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image(stagePATH + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image(stagePATH + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);

				switch (bf)
				{
					case "spooky kids", "tankman":
						boyfriend.y -= 100;
				}
			default:
				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image(stagePATH));
				boyfriend.screenCenter();
				bg.screenCenter();
				bg.scrollFactor.set(0, 0);
				UI.addY(30);
				UI.addX(30);
				add(bg);
		}
		var camPos:FlxPoint = new FlxPoint(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);
		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.zoom = zoom;
		FlxG.camera.focusOn(camFollow.getPosition());
		add(boyfriend);
		add(UI);
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			FlxG.sound.music.stop();
		if (bgm != "none")
			FlxG.sound.playMusic(Paths.specMusic(bgm), 1 - musicVolOffset);
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (boyfriend.animated)
		{
			if (keyPressed([SHIFT]))
				miss = "miss";
			if (keyReleased([SHIFT]))
				miss = "";
			if (keyPressed([LEFT, A]))
			{
				boyfriend.playAnim("left" + miss);
				boyfriend.beep("left");
			}
			if (keyPressed([RIGHT, D]))
			{
				boyfriend.playAnim("right" + miss);
				boyfriend.beep("right");
			}
			if (keyPressed([UP, W]))
			{
				boyfriend.playAnim("up" + miss);
				boyfriend.beep("up");
			}
			if (keyPressed([DOWN, S]))
			{
				boyfriend.playAnim("down" + miss);
				boyfriend.beep("down");
			}
			if (keyPressed([SPACE]))
			{
				boyfriend.SPECIAL();
				if (special != "")
					boyfriend.beep(special);
			}
			if (keyPressed([BACKSPACE, ESCAPE]))
			{
				FlxG.switchState(new SelectStuff());
			}
			if (keyPressed([SEVEN]))
			{
				FlxG.debugger.visible = !FlxG.debugger.visible;
				if (!debuggerMessage)
				{
					PlayState.trace("yo hello debugger user this is the HaxeFlixel debugger\nto read the documentation type  readDocs()  (or type  docs  to get the link itself)  and press enter\nenjoy your stay");
					debuggerMessage = true;
				}
			}
			if (!keyPressed([ANY]) && boyfriend.curAnim.finished)
			{
				boyfriend.playAnim("idle");
			}
		}
	}

	public function keyPressed(KeyArray:Array<FlxKey>):Bool
	{
		return FlxG.keys.anyJustPressed(KeyArray);
	}

	public function keyReleased(KeyArray:Array<FlxKey>):Bool
	{
		return FlxG.keys.anyJustReleased(KeyArray);
	}

	public function debugStuff()
	{
		FlxG.console.registerClass(Character);
		FlxG.console.registerClass(Paths);
		FlxG.console.registerClass(FlxG);
		FlxG.console.registerClass(PlayState);
		FlxG.console.registerClass(Main);
		FlxG.console.registerObject("character", boyfriend);
		FlxG.console.registerObject("characterName", bf);
		FlxG.console.registerObject("docs", HaxeDebuggerDocs);
		FlxG.console.registerFunction("trace", trace);
		FlxG.console.registerFunction("readDocs", readDocs);
		FlxG.console.registerFunction("add", addObject);
	}

	public static function trace(Data:Dynamic)
	{
		FlxG.log.add(Data);
	}

	public function readDocs()
	{
		FlxG.openURL(HaxeDebuggerDocs);
	}

	public function addObject(Object:FlxBasic)
	{
		FlxG.state.add(Object);
	}
}
