TARGET=convert_to_roman
CC=clang
ARCH=`arch`

$(TARGET):
	$(CC) -o $(TARGET) roman.c roman_$(ARCH).S

clean:
	rm -f $(TARGET) *.o

.PHONY:  clean
