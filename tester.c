# include <stdio.h>
# include <stdlib.h>
# include <sys/types.h>
# include <string.h>

ssize_t my_read(int fd, const char *buf, size_t count);
ssize_t my_write(int fd, const char *buf, size_t count);
size_t my_strlen(const char *s);
char *my_strchr(const char *s, int c);
int my_strcmp(const char *s1, const char *s2);
int my_strncmp(const char *s1, const char *s2, size_t num);
int my_strcasecmp(const char *s1, const char *s2);

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
    char letter = 'f';
    char *aft = my_strchr(msg, letter);
    printf("after: %s\n", aft);

    //my_strcmp
    const char s1[] = "test";
    const char s2[] = "test";
    printf("Result A: %d\n", my_strcmp(s1, s2));

    const char s3[] = "test343";
    const char s4[] = "test";
    printf("Result B: %d\n", my_strcmp(s3, s4));

    const char s5[] = "yeplo";
    const char s6[] = "yello";
    printf("Result C: %d\n", my_strcmp(s5, s6));

    const char s7[] = "test";
    const char s8[] = "testadsfssadf";
    printf("Result D: %d\n", my_strcmp(s7, s8));
    printf("%d\n", my_strcmp("apple", "apple"));  // 0
    printf("%d\n", my_strcmp("apple", "apples")); // -1
    printf("%d\n", my_strcmp("banana", "apple")); // 1
   
    //my_strncmp
    printf("////////////////////////////\n");
    
    printf("%d\n", my_strncmp("appledddfdf", "apple", 4)); // 0
    printf("%d\n", my_strncmp("appledddddddddddd", "applesssssssssssss", 10)); // 0
    printf("%d\n", my_strncmp("applezzzzzzzzzzzzzzzzzzz", "applesssssssssssss", 10)); // 0

    printf("////////////////////////////\n");
    
    //my_strcasecmp
    printf("Apple vs. apple test: %d\n", my_strcasecmp("Apple", "apple")); // 0


    return 0;
}
