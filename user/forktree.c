// Fork a binary tree of processes and display their structure.

#include <inc/lib.h>

#define DEPTH 3

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
	//cprintf("%04x forking branch %c\n", sys_getenvid(), branch);
	char nxt[DEPTH+1];
	//cprintf("nxt addr %x\n", nxt);
	
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);

	if (strlen(cur) >= DEPTH)
		return;

	//cprintf("%04x nxt addr %x\n", sys_getenvid(), nxt);
	//cprintf("%04x nxt before %s\n", sys_getenvid(), nxt);
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
	//cprintf("%04x nxt after %s\n", sys_getenvid(), nxt);

	if (fork() == 0) {
		forktree(nxt);
		exit();
	}
}

void
forktree(const char *cur)
{

	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);

	forkchild(cur, '0');
	forkchild(cur, '1');
}

void
umain(int argc, char **argv)
{
	forktree("");
}

