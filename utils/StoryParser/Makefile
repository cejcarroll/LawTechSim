CFLAGS= -g3 -Wall -std=c99 -pedantic

all: StoryParser

StoryParser: StoryParser.o
	${CC} ${CFLAGS} -o $@ $^

StoryParser.o: StoryParser.c

clean:
	rm -f StoryParser
