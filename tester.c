# include <stdio.h>
# include <stdlib.h>
# include <sys/types.h>
# include <string.h>

ssize_t my_read(int fd, const char *buf, size_t count);
ssize_t my_write(int fd, const char *buf, size_t count);
size_t my_strlen(const char *s);
char *my_strchr(const char *s, int c);

int main(void){
	//my_read
	char *buf = malloc(50 * sizeof(char));
	my_read(0, buf, 49);
	my_write(1, buf, 49);
	printf("\n");

	// my_write
	const char msg[] = "Hello from TV land!";
	my_write(1, msg, sizeof(msg) - 1);
	printf("\n");

    //my_strlen
    int my_len = my_strlen(msg);
    int len = strlen(msg);
    printf ("my string length is %d\n", my_len);
    printf ("string length is %d\n", len);

    //my_strchr
    printf("before: %s\n", msg);
    char letter = 'z';
    char *aft = my_strchr(msg, letter);
    printf("after: %s\n", aft);


return 0;
}
