# LawTechSim
CPSC 183: Law, Technology, and Culture - Final Project

## What it is

It's a mini-RPG game on the iOS platform! Currently uses sprites from Pokemon haha. Should be fixed to constraint to the boudaries of fair use hopefully.

## Story File Syntax: Name TBD
Story and dialogue is managed though an original play-script-like dialogue syntax. It works in conjunction with a standalone C program *utils/StoryParser*, which is invoked with file-names of files to parse as arguments in command line. Compile via command ```make```.

For example, if you have the file, *Part-1-story.txt* and *Part-2-story.txt*, convert those into a story file called *ParsedStoryFile* use the command:

	./StoryParser Part-1-story.txt Part-2-story.txt > ParsedStoryFile

Note that the *StoryParser* isn't super robust hahaha. It might be super buggy. After all, it's only a utility tool scrapped together for the some convenience.

Note that because memory management is meh, everything finite component of the syntax is limited to 200 characters to allocate everything on stack.


### Scenes
Each "story-bits" is organized into *Scenes*, in the format:

    SCENE: <name>
    [... contents of scene ...]
    SCENE_END:

Where *name* refers to the name associated with the scene. Note that ```SCENE:``` must be all-caps, and must start at the beginning of a line. The *name* should be unique identifier for that particular scene.

All dialogue and choice tags after a ```SCENE:``` tag before the next ```SCENE:``` identifier is associated with that particular scene.

### Dialogue
Dialog interactions are in the format:

	*: <characterName>: <dialogue>

Where the line begins with an asterisk character.The placeholder *characterName* specifies the character speaking, and *dialogue* is the actual spoken dialogue. Note the end of a *dialogue* is indicated by newline. The actual *dialogue* text should be short enough to fit in one line, i.e. shouldn't be too much to stick outside the chat box on the game.

### Choices
A sequence of dialogue often ends with a *Choice* block, indicating the maximum 3(?) options the player can make in order to jump to another scene. The syntax is block-enclosed, in the format:

	CHOICE:
	<choiceA> : <sceneToJumpToA>
	<choiceB> : <sceneToJumpToB>
	<choiceC> : <sceneToJumpToC>
	CHOICE_END:

Where *choiceA*, *choiceB*, and *choiceC* are all options users can choose from, and *sceneToJumpToA*, *sceneToJumpToB*, and *sceneToJumpToC* are identifiers to different *Scene*s. There can be less than 3 choices. A user choosing one of these options subsequently jumps to the specified scene. Conversely, if a choice is a "cancelling" action, and shouldn't be followed by a jump, use the reserved keyword ```NO_JUMP```.

### Events
A sequence of dialogue in a scene can also end in a *Event*, i.e. a special identifier coupled with the actual game client. For example, for a dialogue that leads to a boss fight, indicate it by

	EVENT: <eventIdentifier>
	ON_SUCCESS: <sceneToJumpToOnEventSuccess>
	ON_FAIL: <sceneToJumpToOnEventFail>
	EVENT_END:

Where *eventIdentifier* specifies what type of event it is, e.g. a fight with a specific boss. The identifier here is tied directly with the client, so the actual name should be agreed upon (i.e. shouldn't be arbitrary!). The ```ON_SUCCESS:``` and ```ON_FAIL:``` are both optional specifiers to jump to specific scenes on the success or failure of a certain event.

### State Flags
State flags are used to indicate whether or not some task was completed. All flags are initially in the ```false``` state. To turn some flag ```true```, i.e. some task was completed, indicate it by

	COMPLETED: <flagIdentifier>

### Scenarios
*Scenarios* is how you link different scenes to different characters. Scenes are played based on whatever *State flag* is ```true``` when the specified character is interacted with. The syntax is:

	SCENARIO: <characterIdentifier>
	IF: <stateFlagA> : <sceneToJumpToA>
	IF: <stateFlagB> : <sceneToJumpToB>
	[... and many more IF if necessary]
	DEFAULT: <sceneToDefaultTo>


where *characterIdentifier* specifies which character to link the scenes to. After an ```IF:``` *stateFlagA* and *stateFlagB* represent different *State Flags* that will be checked if ```true```, whereas *sceneToJumpToA* and *sceneToJumpToB* specify scenes that will be jumped to when specific conditions are satisfied. For example, if *stateFlagA* is true, the story will jump to *sceneToJumpToA*.

Note that the the story will jump to whatever scene the first *State Flag* is satisfied, so if there are multiple ```IF```s, order matters! If no *State Flag* is resolved to ```true```, the story will jump to *sceneToDefaultTo*. Jumps to a scene that require multiple *State Flags* to be examined are currently unsupported since we probably don't need them for this project.

### Comments

You can insert comments for your own needs that the script parser ignores by using the ```#``` character. Lines starting with ```#``` are ignored completely. For example

	# This text is completely ignored by the parser!

Lines with incorrect syntax is ignored too.

### Examples

Here are some examples of the aformentioned syntax. Hopefully this will work in practice hahaha.

##### 1) Example with two scenes

	# Link Character Brad to Scenes
	SCENARIO: Brad
	IF: Homework Completed : Brad is Happy
	DEFAULT: Brad is Unhappy

	# Scene where Brad is impressed with your work ethic
	SCENE: Brad is Happy
	*:Brad: Good Job child. You get an A fo sho.
	*:Student: Thanks guy. You're the bestest.
	SCENE_END:

	# Scene where Brad is unimpressed by your lack of homework
	SCENE: Brad is Unhappy
	*:Brad: You still haven't done your homework? That's whack
	SCENE_END:


##### 2) Example with Choices and Event

	# Linking Character Brad with scenes omitted for brevity

	# Starting Scene with choice
	SCENE: Brad asks question

	*:Brad: Did you complete four reading responses?

	# User answers Brad's question
	CHOICE:
	Yes I did     : Brad gives you an A
	No I didn't   : Brad fails you
	Ignore him    : NO_JUMP
	CHOICE_END:

	SCENE_END:


	# You answer Yes Scenario
	SCENE: Brad gives you an A
	*:Brad: Wow, I'm impressed! You get an A.

	SCENE_END:


	# You answer No Scenario
	SCENE: Brad fails you
	*:Brad: Wow, were you not listening in class? You get a B-.

	EVENT: You lose
	EVENT_END:

	SCENE_END:


##### 3) Example with State flags

	SCENARIO: Brad
	IF: Had a conversation with Brad: You have talked to Brad
	DEFAULT: You have never talked to Brad

	# when you talk with brad for the first time
	SCENE: You have never talked to Brad

	*:Brad: I don't think we've met before. I'm Brad
	*:Student: Hi! I'm student, the swaggiest student on the block

	COMPLETED: Had a conversation with Brad

	SCENE_END:


	# When you've alredy talked with Brad once
	SCENE: You have talked to Brad

	*:Brad: Hey student. How's your day?
	*:Student: All is good Brad. All is good.

	SCENE_END:


### Tips & Tricks

Few tips and tricks to improve your experience. Unfortunately I'm probably not going to spend much time making the parser robust since it's not really part of the original project, only a utility to help story-making more decoupled with development of iOS game. That being said, following these tips should help not throw off the parser!

1. Put finite syntactic blocks in chunks, and don't deviate too much from the suggestions above
2. Divide larger blocks of dialogue into different files, e.g. file for different characters
2. Make sure the identifiers for scenarios, characters, and events match what you're referring to consistently across the script. Adopting a convention is useful, for example, omitting spaces and capitalizing every beginning of a word (e.g. WelcomeDialogueScene)
3. Don't use the ```:``` and newlines in unexpected manners, as this is what the parser uses as references to decompose content. For example, a dialogue speech should continue on one line, and never include a newline.
4. Don't use syntax keywords or reserved keywords in dialogue, for example ```IF:``` and ```NO_JUMP```, etc. Note that these must be capitalized anf followed by colon to trigger syntax parsing.
