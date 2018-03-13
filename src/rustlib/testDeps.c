#include <neo4j-client.h>
#include <stdio.h>

int main() {
    printf("%s", libneo4j_client_version());
}
