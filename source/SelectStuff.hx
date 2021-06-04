package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import haxe.Http;
import lime.app.Application;
import lime.utils.Assets;
import openfl.utils.Dictionary;
import sys.FileSystem;

using StringTools;

class SelectStuff extends FlxState
{
	var bfDropdown:FlxUIDropDownMenu;
	var bgDropdown:FlxUIDropDownMenu;
	var spDropdown:FlxUIDropDownMenu;
	var msDropdown:FlxUIDropDownMenu;
	var flippyChek:FlxUICheckBox;
	var flippYChek:FlxUICheckBox;
	var waterEnter:FlxUIInputText;
	var waterAlpha:FlxUINumericStepper;
	var playButton:FlxButton;
	var outdatedBn:FlxButton;
	var characters:Array<String>;
	var backgrounds:Array<String>;
	var bgm:Array<String>;
	var offset:Float = 50;

	public static var NOT_WORKING:String = " (not working)";

	public static var characterSpecials:Dictionary<String, Array<String>> = new Dictionary<String, Array<String>>();
	public static var noSounds:Dictionary<String, Array<String>> = new Dictionary<String, Array<String>>();

	public override function create()
	{
		super.create();
		FlxG.mouse.visible = true;

		outdatedBn = new FlxButton(0, 0, "Outdated Version", getNewVersion);
		outdatedBn.height *= 2;
		outdatedBn.visible = false;
		checkVersion();

		var bfDropdownHeader:FlxText = new FlxText(0, 0, 0, "Character");
		bfDropdownHeader.alignment = CENTER;
		var bgDropdownHeader:FlxText = new FlxText(0, 0, 0, "Stage");
		bgDropdownHeader.alignment = CENTER;
		var spDropdownHeader:FlxText = new FlxText(0, 0, 0, "Special");
		spDropdownHeader.alignment = CENTER;
		var msDropdownHeader:FlxText = new FlxText(0, 0, 0, "Music");
		msDropdownHeader.alignment = CENTER;
		var waterEnterHeader:FlxText = new FlxText(0, 0, 0, "Watermark");
		waterEnterHeader.alignment = CENTER;
		var waterAlphaHeader:FlxText = new FlxText(0, 0, 0, "Watermark Visibility (Alpha)");
		waterAlphaHeader.alignment = CENTER;

		characterSpecials.set("BOYFRIEND", ["hey", "firstDeath", "deathLoop", "deathConfirm", "scared"]);
		characterSpecials.set("bf-christmas", ["hey"]);
		characterSpecials.set("spooky kids", ["spooky dance"]);
		characterSpecials.set("tankman", ["ugh", "pretty good"]);
		characterSpecials.set("bf-holding-gf", ["catch"]);

		noSounds.set("bf-holding-gf", ["catch"]);

		playButton = new FlxButton(0, 0, "Play", play);
		playButton.screenCenter();
		playButton.y -= offset;

		waterEnter = new FlxUIInputText(0, 0, 70, "", 8);
		waterEnter.screenCenter();
		waterEnter.y = playButton.y + offset;
		waterEnter.text = PlayState.watermark;
		waterEnterHeader.x = waterEnter.x;
		waterEnterHeader.y = waterEnter.y + (offset / 2);

		waterAlpha = new FlxUINumericStepper(0, 0, 0.1, PlayState.watermarkAlpha, 0.0, 1.0, 1);
		waterAlpha.screenCenter();
		waterAlpha.x = waterEnter.x + (offset * 3);
		waterAlpha.y = waterEnter.y;
		waterAlpha.value = PlayState.watermarkAlpha;
		waterAlphaHeader.x = waterAlpha.getGraphicMidpoint().x;
		waterAlphaHeader.y = waterAlpha.y + (offset / 2);

		flippyChek = new FlxUICheckBox(0, 0, null, null, "Flip Character", 100);
		flippyChek.screenCenter();
		flippyChek.y = waterEnter.y + offset;
		flippyChek.checked = PlayState.flip;

		characters = textThing(Paths.txt("characterList"));
		characters.sort(sortArray);
		bfDropdown = new FlxUIDropDownMenu(0, 0, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			PlayState.bf = characters[Std.parseInt(character)];
			var exists:Bool = characterSpecials.exists(PlayState.bf);
			spDropdown.visible = exists;
			if (exists)
			{
				spDropdown.setData(FlxUIDropDownMenu.makeStrIdLabelArray(characterSpecials[PlayState.bf], true));
				spDropdownHeader.text = "Special";
			}
			else
				spDropdownHeader.text = "";
		});
		bfDropdown.screenCenter();
		bfDropdown.y = playButton.y - (offset * 4);
		bfDropdown.selectedLabel = PlayState.bf;
		bfDropdownHeader.x = bfDropdown.getGraphicMidpoint().x;
		bfDropdownHeader.y = bfDropdown.y + (offset / 2);

		bgm = folderThing("assets/music", ["wav", "ogg", "mp3"]);
		bgm.sort(sortArray);
		bgm.insert(0, "none");
		msDropdown = new FlxUIDropDownMenu(0, 0, FlxUIDropDownMenu.makeStrIdLabelArray(bgm, true), function(music:String)
		{
			PlayState.bgm = bgm[Std.parseInt(music)];
		});
		msDropdown.dropDirection = FlxUIDropDownMenuDropDirection.Down;
		msDropdown.screenCenter();
		msDropdown.y = bfDropdown.y;
		msDropdown.x = bfDropdown.x - (offset * 3);
		msDropdown.selectedLabel = PlayState.bgm;
		msDropdownHeader.x = msDropdown.getGraphicMidpoint().x;
		msDropdownHeader.y = msDropdown.y + (offset / 2);

		backgrounds = textThing(Paths.txt("stageList"));
		backgrounds.sort(sortArray);
		bgDropdown = new FlxUIDropDownMenu(0, 0, FlxUIDropDownMenu.makeStrIdLabelArray(backgrounds, true), function(background:String)
		{
			PlayState.stage = backgrounds[Std.parseInt(background)];
		});
		bgDropdown.screenCenter();
		bgDropdown.y = bfDropdown.y;
		bgDropdown.x = bfDropdown.x + (offset * 3);
		bgDropdown.selectedLabel = PlayState.stage;
		bgDropdownHeader.x = bgDropdown.getGraphicMidpoint().x;
		bgDropdownHeader.y = bgDropdown.y + (offset / 2);

		spDropdown = new FlxUIDropDownMenu(0, 0, FlxUIDropDownMenu.makeStrIdLabelArray([""], true), function(special:String)
		{
			PlayState.special = spDropdown.selectedLabel;
		});
		if (characterSpecials.exists(PlayState.bf))
		{
			spDropdown.setData(FlxUIDropDownMenu.makeStrIdLabelArray(characterSpecials[PlayState.bf], true));
			spDropdown.selectedLabel = PlayState.special;
			spDropdownHeader.text = "Special";
		}
		else
			spDropdownHeader.text = "";
		spDropdown.visible = characterSpecials.exists(PlayState.bf);
		spDropdown.screenCenter();
		spDropdown.y = bgDropdown.y;
		spDropdown.x = bgDropdown.x + (offset * 3);
		spDropdownHeader.x = spDropdown.getGraphicMidpoint().x;
		spDropdownHeader.y = spDropdown.y + (offset / 2);

		add(outdatedBn);
		add(playButton);
		add(waterEnterHeader);
		add(waterEnter);
		add(waterAlphaHeader);
		add(waterAlpha);
		add(flippyChek);
		add(bfDropdownHeader);
		add(bfDropdown);
		add(msDropdownHeader);
		add(msDropdown);
		add(bgDropdownHeader);
		add(bgDropdown);
		add(spDropdownHeader);
		add(spDropdown);
	}

	private function play()
	{
		PlayState.bf = bfDropdown.selectedLabel;
		PlayState.bgm = msDropdown.selectedLabel;
		PlayState.stage = bgDropdown.selectedLabel;
		PlayState.special = spDropdown.selectedLabel;
		PlayState.flip = flippyChek.checked;
		PlayState.watermark = waterEnter.text;
		PlayState.watermarkAlpha = waterAlpha.value;
		FlxG.switchState(new PlayState());
	}

	public function textThing(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public function textThing1Line(path:String):String
	{
		return Assets.getText(path);
	}

	public function removeExtension(file:String)
	{
		var extensionAndOut:Array<String> = file.split(".");
		return extensionAndOut[0];
	}

	public function sortArray(a:String, b:String):Int
	{
		a = a.toUpperCase();
		b = b.toUpperCase();

		if (a < b)
		{
			return -1;
		}
		else if (a > b)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}

	public function folderThing(path:String, ?requiredExtensions:Null<Array<String>>, ?musical:Bool = true):Array<String>
	{
		var folderItems:Array<String> = [];

		if (!path.endsWith("/"))
			path += "/";

		if (FileSystem.exists(path))
		{
			for (file in FileSystem.readDirectory(path))
			{
				if (requiredExtensions != null)
				{
					for (extension in requiredExtensions)
					{
						if (file.endsWith("." + extension))
						{
							folderItems.push(file);
						}
					}
				}
				else
				{
					folderItems.push(file);
				}
			}
		}

		return folderItems;
	}

	public static function endsWith(string:String, suffix:String)
	{
		return string.endsWith(suffix);
	}

	public function checkVersion()
	{
		var curVersion:Float = Std.parseFloat(Application.current.meta.get("version"));
		var http:Http = new Http("https://raw.githubusercontent.com/Sayo-Exo/FNFAnims/main/coolversion.txt");

		http.onData = function(data:String)
		{
			var newVersion:Float = Std.parseFloat(data.trim().toLowerCase());
			trace("version checking:\ncool new version: " + newVersion + "\ncurrent version: " + curVersion);
			if (newVersion == curVersion)
			{
				trace("GOOD VERSION");
				outdatedBn.visible = false;
			}
			if (curVersion < newVersion)
			{
				trace("BAD VERSION");
				outdatedBn.visible = true;
			}
		}

		http.onError = function(error)
		{
			trace("whoops an error " + error);
		}

		http.request();
	}

	public function getNewVersion()
	{
		FlxG.openURL("https://github.com/Sayo-Exo/FNFAnims/releases");
	}
}
