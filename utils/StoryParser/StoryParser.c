#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

// For debug
// #define LOG

#define BUF_SIZE (250)

// FIXME: Function args should be enum
#define WHTSPC_INC    (0)
#define WHTSPC_OMT    (1)
#define WHTSPC_NO_PADDING (0)
#define FMT_NONE      (0)
#define FMT_LOWERCASE (1)

#define SCENE_TAG_OPEN ("<scene id=\"%s\">\n")
#define SCENE_TAG_CLOSE ("</scene>\n\n")

#define DIALOG_TAG ("\t<dialogue speaker=\"%s\" content=\"%s\"/>\n")

#define CHOICEGROUP_TAG_OPEN  ("<choicegroup>\n")
#define CHOICE_TAG            ("\t<choice option=\"%s\" onSelection=\"%s\"/>\n")
#define CHOICEGROUP_TAG_CLOSE ("</choicegroup>\n")

#define EVENT_TAG       ("\t<event id=\"%s\" onSuccess=\"%s\" onFail=\"%s\">\n")

#define STATE_TAG       ("\t<toggle id=\"%s\"/>\n")

#define SCENARIO_BLK_TAG_OPEN       ("<scenariogroup character=\"%s\">\n")
#define SCENARIO_WITH_COND_TAG      ("\t<scenario cond=\"%s\"  jumpTo=\"%s\"/>\n")
#define SCENARIO_DEFAULT_TAG        ("\t<scenario cond=\"DEFAULT\" jumpTo=\"%s\"/>\n")
#define SCENARIO_BLK_TAG_CLOSE      ("</scenariogroup>\n\n")


// FIXME: Should be more robust
// FIXME: Should have more consistant loop syntax
// FIXME: Should have more explanatory error messages

/**
 Lower case a buffer of characters. Help unify different identifiers
 @param buf string buffer to lower-case
 */
void lowerCaseBuffer(char *buf)
{
    int len; /*   Length of string in buffer   */

    len = strlen(buf);

    for (int i = 0; i < len; i++)
    {
        if (isupper(buf[i]))
            buf[i] = tolower(buf[i]);
    }
}

/**
 Move FILE to first nonwhitespace character
 */
void skipToNonwhitespace(FILE *f)
{
    int c; /*   Character read   */

    while ((c = fgetc(f)) != EOF)
    {
        if (!isspace(c))
        {
            ungetc(c, f);
            break;
        }
    }
}

/**
 Move file pointer until after specified character
 */
void skipUntilChar(FILE *f, char t)
{
    int c; /*   Character read   */

    while ((c = fgetc(f)) != EOF)
    {
        if (c != t) break;
    }
}

/**
 Grab characters until certain character or newline is reached
 @warn doesn't check that it's within memory bounds because YOLO
 */
int grabUntilChar(FILE *f, char t, char *buf, int whtOpt, int fmtOpt)
{
    int bufLen = 0;        /*   length of name of buffer   */
    int whiteSpaceLen = 0; /*   length of consecutive whitespace   */
    int c;                 /*   character read   */

    buf[0] = '\0';

    if (whtOpt == WHTSPC_NO_PADDING || whtOpt == WHTSPC_OMT)
        skipToNonwhitespace(f);

    // Read until target character
    while ((c = fgetc(f)) != EOF)
    {
        if (c == t || c == '\n')
            break;

        if (whtOpt == WHTSPC_OMT && isspace(c))
            continue;

        buf[bufLen] = c;
        bufLen++;

        if (whtOpt == WHTSPC_NO_PADDING  && isspace(c))
            whiteSpaceLen++;
        else
            whiteSpaceLen = 0;

    }

    buf[bufLen - whiteSpaceLen] = '\0';

    if (fmtOpt == FMT_LOWERCASE)
        lowerCaseBuffer(buf);

    #ifdef LOG
    fprintf(stderr, "TOKEN: %s\n", buf);
    #endif

    if (bufLen - whiteSpaceLen == 0)
        return -1;

    return 0;
}



/**
 Parse an choice block
 Expected to be alinged after CHOICE:, parses until CHOICE_END

 @return 0 if success, -1 on failure
 */
int parseChoices(FILE *f)
{
    char option[BUF_SIZE]; /*   Option that can be chosen   */
    char scene[BUF_SIZE];  /*   scene to jump to   */

    printf(CHOICEGROUP_TAG_OPEN);

    while (1)
    {
        grabUntilChar(f, ':', option, WHTSPC_NO_PADDING, FMT_NONE);

        if (strcmp(option, "CHOICE_END") == 0)
            break;

        grabUntilChar(f, '\n', scene, WHTSPC_OMT, FMT_LOWERCASE);

        printf(CHOICE_TAG, option, scene);
    }



    printf(CHOICEGROUP_TAG_CLOSE);


    return 0;
}

/**
 Parse an event trigger tag
 Expected to be aligned after EVENT:

 @return 0 on success, -1 on failure
 */
int parseEvents(FILE *f)
{
    char buf[BUF_SIZE];          /*   temp buf for tokens   */
    char event[BUF_SIZE];        /*   name of event   */
    char successScene[BUF_SIZE]; /*   Scene to jump to on success   */
    char failureScene[BUF_SIZE]; /*   Scene to jump to on failure   */
    int isEventEnd = 0;

    // Default values for jumps
    strcpy(successScene, "NO_JUMP");
    strcpy(failureScene, "NO_JUMP");

    grabUntilChar(f, ':', event, WHTSPC_OMT, FMT_LOWERCASE);


    while (!isEventEnd)
    {
        grabUntilChar(f, ':', buf, WHTSPC_OMT, FMT_NONE);

        if (strcmp(buf, "EVENT_END") == 0)
            isEventEnd = 1;
        else if (strcmp(buf, "ON_SUCCESS") == 0)
            grabUntilChar(f, '\n', successScene, WHTSPC_OMT, FMT_NONE);
        else if (strcmp(buf, "ON_FAILURE") == 0)
            grabUntilChar(f, '\n', failureScene, WHTSPC_OMT, FMT_NONE);
    }

    printf(EVENT_TAG, event, successScene, failureScene);

    return 0;
}


/**
 Parse a StateFlag update, and writes to stdout
 Expected to be aligned after COMPLETED:

 @return 0 if success, -1 on failure
 */
int parseStateFlag(FILE *f)
{
    char stateFlag[BUF_SIZE];

    grabUntilChar(f, '\n', stateFlag, WHTSPC_OMT, FMT_LOWERCASE);

    printf(STATE_TAG, stateFlag);

    return 0;
}


/**
 Parse a line of dialogue by character
 Expected to be aligned right after '*' character

 @return 0 if success, -1 if failure
 */
int parseDialogue(FILE *f)
{
    char name[BUF_SIZE];
    char content[BUF_SIZE];

    grabUntilChar(f, ':', name, WHTSPC_NO_PADDING, FMT_NONE);
    grabUntilChar(f, '\n', content, WHTSPC_NO_PADDING, FMT_NONE);
    printf(DIALOG_TAG, name, content);

    return 0;
}


/**
 Parse contents of a scene, like dialogue, choices, etc until reaching SCENE_END tag

 @param paramName paramDesc

 @return 0 on success, -1 on failure
 */
int parseSceneContents(FILE *f)
{
    char buf[BUF_SIZE]; /*   buffer to hold tokens   */
    int status;
    int isEnd = 0;

    while (!isEnd)
    {
        skipToNonwhitespace(f);
        grabUntilChar(f, ':', buf, WHTSPC_NO_PADDING, FMT_NONE);

        if (strcmp(buf, "COMPLETED") == 0)
            status = parseStateFlag(f);
        else if (strcmp(buf, "CHOICE") == 0)
            status = parseChoices(f);
        else if (strcmp(buf, "*") == 0)
            status = parseDialogue(f);
        else if (strcmp(buf, "EVENT") == 0)
            status = parseEvents(f);
        else if (strcmp(buf, "SCENE_END") == 0)
            isEnd = 1;
    }



    return 0;
}

/**
 Parse a Scene and all contained dialogue, flag updates, events, and choices
 Expects to be aligned after a SCENE: tag
 Writes it's contents and containing tag to stdout

 @return 0 if success, -1 on failure
 */
int parseScene(FILE *f)
{
    char scene[BUF_SIZE];   /*   name of scene   */
    int status;

    // Read scene name until newline
    grabUntilChar(f, '\n', scene, WHTSPC_OMT, FMT_LOWERCASE);
    printf(SCENE_TAG_OPEN, scene);

    // Parse inner contents
    status = parseSceneContents(f);

    printf(SCENE_TAG_CLOSE);

    return 0;
}

/**
 Parse contents of scenario of specified syntax until reaching SCENE_END

 @return 0 if success, -1 on failure
 */
int parseScenarioContents(FILE *f)
{
    char buf[BUF_SIZE];     /*   temp buffer to read symbols to   */
    char flag[BUF_SIZE];    /*   Name of flag   */
    char scene[BUF_SIZE];   /*   length of scene to jump to   */

    int isDef = 0;         /*   flag to indicate line specifies default jump   */

    /*   Parse until DEFAULT: line   */
    while (!isDef)
    {

        if (grabUntilChar(f, ':', buf, WHTSPC_OMT, FMT_NONE))
        {
            fprintf(stderr, "Error parsing contents of scenario\n");
            return -1;
        }

        if (strcmp(buf, "IF") == 0)
        {
            grabUntilChar(f, ':', flag, WHTSPC_OMT, FMT_LOWERCASE);
            grabUntilChar(f, '\n', scene, WHTSPC_OMT, FMT_LOWERCASE);
            printf(SCENARIO_WITH_COND_TAG, flag, scene);
        }
        else if (strcmp(buf, "DEFAULT") == 0)
        {
            grabUntilChar(f, '\n', scene, WHTSPC_OMT, FMT_LOWERCASE);
            printf(SCENARIO_DEFAULT_TAG, scene);
            isDef = 1;
        }
        else
        {
            fprintf(stderr, "Error parsing contents of scenario\n");
            return -1;
        }
    }

    return 0;
}

/**
 Parse a Scenario block based on specified syntax
 Expects to be aligned after a SCENARIO: tag
 Writes directly to stdout.

 @return 0 if success, -1 on failure
 */
int parseScenario(FILE *f)
{
    char scenario[BUF_SIZE];   /*   name of scenario   */
    int status;

    if (grabUntilChar(f, '\n', scenario, WHTSPC_OMT, FMT_NONE))
    {
        fprintf(stderr, "Failed to parse scenario name\n");
        return -1;
    }

    fprintf(stderr, "Parsing scenario %s\n", scenario);

    printf(SCENARIO_BLK_TAG_OPEN, scenario);
    status = parseScenarioContents(f);
    printf(SCENARIO_BLK_TAG_CLOSE);

    return status;
}

/**
 Parse all Scenarios and Scenes existing at file level,
 ignoring all other tags.

 @return 0 if success, -1 on failure
 */
int parseFile(FILE *f)
{
    int c;              /*   Character read   */
    char buf[BUF_SIZE];  /*   Buffer to read tags into   */
    int bufLen = 0;     /*   Length of buffer    */
    int status = 0;       /*   Flag to detect failure   */

    while ((c = fgetc(f)) != EOF)
    {

        if (c == '\n')
        {
            buf[0] = '\0';
            bufLen = 0;
            continue;
        }

        if (isspace(c))
            continue;

        if (c == '#')
        {
            skipUntilChar(f, '\n');
            continue;
        }


        buf[bufLen] = c;
        bufLen++;
        buf[bufLen] = '\0';

        if (strcmp(buf, "SCENARIO") == 0)
        {
            skipUntilChar(f, ':');
            status = parseScenario(f);

            buf[0] = '\0';
            bufLen = 0;
        }
        else if (strcmp(buf, "SCENE") == 0)
        {
            skipUntilChar(f, ':');
            status = parseScene(f);

            buf[0] = '\0';
            bufLen = 0;
        }

        if (bufLen + 1 >= BUF_SIZE)
        {
            fprintf(stderr, "Parse Error\n");
            return -1;
        }

        // some error occured
        if (status)
            break;
    }


    return status;
}

int main(int argc, const char **argv)
{
    FILE *inFile; /*   File to read from   */
    int numFiles; /*   Number of files to prse   */

    numFiles = argc - 1;

    for (int i = 0; i < numFiles; i++)
    {
        inFile = fopen(argv[i+1], "r");

        if (!inFile)
        {
            perror("fopen");
            exit(EXIT_FAILURE);
        }

        if (parseFile(inFile) != 0)
        {
            fprintf(stderr, "Error occured while parsing %s\n", argv[i+1]);
            exit(EXIT_FAILURE);
        }

        fclose(inFile);
    }

    fprintf(stderr, "Parsed %d file(s) successfully\n", numFiles);

    /*   TODO: probably should do that # scenarios match # referenced?   */

    exit(EXIT_SUCCESS);
}
