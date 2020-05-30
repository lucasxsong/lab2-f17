
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 2e 10 80       	mov    $0x80102e30,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 00 6e 10 	movl   $0x80106e00,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 30 40 00 00       	call   80104090 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 07 6e 10 	movl   $0x80106e07,0x4(%esp)
8010009b:	80 
8010009c:	e8 df 3e 00 00       	call   80103f80 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 95 40 00 00       	call   80104180 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 0a 41 00 00       	call   80104270 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 4f 3e 00 00       	call   80103fc0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 e2 1f 00 00       	call   80102160 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 0e 6e 10 80 	movl   $0x80106e0e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 ab 3e 00 00       	call   80104060 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 97 1f 00 00       	jmp    80102160 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 1f 6e 10 80 	movl   $0x80106e1f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 6a 3e 00 00       	call   80104060 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 1e 3e 00 00       	call   80104020 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 72 3f 00 00       	call   80104180 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 1b 40 00 00       	jmp    80104270 <release>
    panic("brelse");
80100255:	c7 04 24 26 6e 10 80 	movl   $0x80106e26,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 49 15 00 00       	call   801017d0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 ed 3e 00 00       	call   80104180 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 33 34 00 00       	call   801036e0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 78 39 00 00       	call   80103c40 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 5a 3f 00 00       	call   80104270 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 d2 13 00 00       	call   801016f0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 3c 3f 00 00       	call   80104270 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 b4 13 00 00       	call   801016f0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 25 24 00 00       	call   801027a0 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 2d 6e 10 80 	movl   $0x80106e2d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 9f 77 10 80 	movl   $0x8010779f,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 fc 3c 00 00       	call   801040b0 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 41 6e 10 80 	movl   $0x80106e41,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 e2 53 00 00       	call   801057f0 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 32 53 00 00       	call   801057f0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 26 53 00 00       	call   801057f0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 1a 53 00 00       	call   801057f0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 5f 3e 00 00       	call   80104360 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 a2 3d 00 00       	call   801042c0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 45 6e 10 80 	movl   $0x80106e45,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 70 6e 10 80 	movzbl -0x7fef9190(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 c9 11 00 00       	call   801017d0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 6d 3b 00 00       	call   80104180 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 35 3c 00 00       	call   80104270 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 aa 10 00 00       	call   801016f0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 78 3b 00 00       	call   80104270 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 58 6e 10 80       	mov    $0x80106e58,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 e4 39 00 00       	call   80104180 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 5f 6e 10 80 	movl   $0x80106e5f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 b6 39 00 00       	call   80104180 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 44 3a 00 00       	call   80104270 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 19 35 00 00       	call   80103dd0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 84 35 00 00       	jmp    80103eb0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 68 6e 10 	movl   $0x80106e68,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 26 37 00 00       	call   80104090 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 54 19 00 00       	call   801022f0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 2f 2d 00 00       	call   801036e0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 94 21 00 00       	call   80102b50 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 79 15 00 00       	call   80101f40 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 bc 01 00 00    	je     80100b8d <exec+0x1ed>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 17 0d 00 00       	call   801016f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 a5 0f 00 00       	call   801019a0 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 48 0f 00 00       	call   80101950 <iunlockput>
    end_op();
80100a08:	e8 b3 21 00 00       	call   80102bc0 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 cf 5f 00 00       	call   80106a00 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 0d 0f 00 00       	call   801019a0 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 89 5d 00 00       	call   80106860 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 88 5c 00 00       	call   801067a0 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 52 5e 00 00       	call   80106980 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 15 0e 00 00       	call   80101950 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 7b 20 00 00       	call   80102bc0 <end_op>
  int z = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((z = allocuvm(pgdir, z, z + PGSIZE)) == 0)
80100b55:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 ef 5c 00 00       	call   80106860 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	75 33                	jne    80100ba8 <exec+0x208>
    freevm(pgdir);
80100b75:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b7b:	89 04 24             	mov    %eax,(%esp)
80100b7e:	e8 fd 5d 00 00       	call   80106980 <freevm>
  return -1;
80100b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b88:	e9 85 fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b8d:	e8 2e 20 00 00       	call   80102bc0 <end_op>
    cprintf("exec: fail\n");
80100b92:	c7 04 24 81 6e 10 80 	movl   $0x80106e81,(%esp)
80100b99:	e8 b2 fa ff ff       	call   80100650 <cprintf>
    return -1;
80100b9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba3:	e9 6a fe ff ff       	jmp    80100a12 <exec+0x72>
  clearpteu(pgdir, (char*)(z - PGSIZE));
80100ba8:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100bae:	2d 00 10 00 00       	sub    $0x1000,%eax
80100bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bb7:	89 3c 24             	mov    %edi,(%esp)
80100bba:	e8 f1 5e 00 00       	call   80106ab0 <clearpteu>
 if(allocuvm(pgdir, KERNBASE - 1 - PGSIZE, KERNBASE - 1) == 0)
80100bbf:	c7 44 24 08 ff ff ff 	movl   $0x7fffffff,0x8(%esp)
80100bc6:	7f 
80100bc7:	c7 44 24 04 ff ef ff 	movl   $0x7fffefff,0x4(%esp)
80100bce:	7f 
80100bcf:	89 3c 24             	mov    %edi,(%esp)
80100bd2:	e8 89 5c 00 00       	call   80106860 <allocuvm>
80100bd7:	85 c0                	test   %eax,%eax
80100bd9:	74 9a                	je     80100b75 <exec+0x1d5>
  for(argc = 0; argv[argc]; argc++) {
80100bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bde:	8b 00                	mov    (%eax),%eax
80100be0:	85 c0                	test   %eax,%eax
80100be2:	0f 84 7b 01 00 00    	je     80100d63 <exec+0x3c3>
80100be8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100beb:	31 f6                	xor    %esi,%esi
80100bed:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
80100bf2:	8d 51 04             	lea    0x4(%ecx),%edx
80100bf5:	89 cf                	mov    %ecx,%edi
80100bf7:	89 d1                	mov    %edx,%ecx
80100bf9:	89 f2                	mov    %esi,%edx
80100bfb:	89 fe                	mov    %edi,%esi
80100bfd:	89 cf                	mov    %ecx,%edi
80100bff:	eb 0c                	jmp    80100c0d <exec+0x26d>
80100c01:	83 c7 04             	add    $0x4,%edi
    if(argc >= MAXARG)
80100c04:	83 fa 20             	cmp    $0x20,%edx
80100c07:	0f 84 68 ff ff ff    	je     80100b75 <exec+0x1d5>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0d:	89 04 24             	mov    %eax,(%esp)
80100c10:	89 95 e8 fe ff ff    	mov    %edx,-0x118(%ebp)
80100c16:	e8 c5 38 00 00       	call   801044e0 <strlen>
80100c1b:	f7 d0                	not    %eax
80100c1d:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c1f:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c21:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c24:	89 04 24             	mov    %eax,(%esp)
80100c27:	e8 b4 38 00 00       	call   801044e0 <strlen>
80100c2c:	83 c0 01             	add    $0x1,%eax
80100c2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c33:	8b 06                	mov    (%esi),%eax
80100c35:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c39:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c3d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c43:	89 04 24             	mov    %eax,(%esp)
80100c46:	e8 a5 60 00 00       	call   80106cf0 <copyout>
80100c4b:	85 c0                	test   %eax,%eax
80100c4d:	0f 88 22 ff ff ff    	js     80100b75 <exec+0x1d5>
    ustack[3+argc] = sp;
80100c53:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
80100c59:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100c5f:	89 fe                	mov    %edi,%esi
80100c61:	8b 07                	mov    (%edi),%eax
    ustack[3+argc] = sp;
80100c63:	89 9c 95 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100c6a:	83 c2 01             	add    $0x1,%edx
80100c6d:	85 c0                	test   %eax,%eax
80100c6f:	75 90                	jne    80100c01 <exec+0x261>
80100c71:	89 d6                	mov    %edx,%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c73:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c7a:	89 da                	mov    %ebx,%edx
80100c7c:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c7e:	83 c0 0c             	add    $0xc,%eax
80100c81:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c83:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c87:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c91:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[3+argc] = 0;
80100c95:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c9c:	00 00 00 00 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca0:	89 04 24             	mov    %eax,(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100ca3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100caa:	ff ff ff 
  ustack[1] = argc;
80100cad:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb3:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb9:	e8 32 60 00 00       	call   80106cf0 <copyout>
80100cbe:	85 c0                	test   %eax,%eax
80100cc0:	0f 88 af fe ff ff    	js     80100b75 <exec+0x1d5>
  for(last=s=path; *s; s++)
80100cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80100cc9:	0f b6 10             	movzbl (%eax),%edx
80100ccc:	84 d2                	test   %dl,%dl
80100cce:	74 19                	je     80100ce9 <exec+0x349>
80100cd0:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd3:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100cd6:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cd9:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cdc:	0f 44 c8             	cmove  %eax,%ecx
80100cdf:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100ce2:	84 d2                	test   %dl,%dl
80100ce4:	75 f0                	jne    80100cd6 <exec+0x336>
80100ce6:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ce9:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cef:	8b 45 08             	mov    0x8(%ebp),%eax
80100cf2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cf9:	00 
80100cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cfe:	89 f8                	mov    %edi,%eax
80100d00:	83 c0 6c             	add    $0x6c,%eax
80100d03:	89 04 24             	mov    %eax,(%esp)
80100d06:	e8 95 37 00 00       	call   801044a0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d11:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->tf->eip = elf.entry;  // main
80100d14:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100d17:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d1a:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100d20:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 47 18             	mov    0x18(%edi),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
curproc->stackPages = 1;
80100d31:	c7 47 7c 01 00 00 00 	movl   $0x1,0x7c(%edi)
  cprintf("Initial number of pages by the process: %d\n", curproc->stackPages);
80100d38:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80100d3f:	00 
80100d40:	c7 04 24 90 6e 10 80 	movl   $0x80106e90,(%esp)
80100d47:	e8 04 f9 ff ff       	call   80100650 <cprintf>
 switchuvm(curproc);
80100d4c:	89 3c 24             	mov    %edi,(%esp)
80100d4f:	e8 ac 58 00 00       	call   80106600 <switchuvm>
  freevm(oldpgdir);
80100d54:	89 34 24             	mov    %esi,(%esp)
80100d57:	e8 24 5c 00 00       	call   80106980 <freevm>
  return 0;
80100d5c:	31 c0                	xor    %eax,%eax
80100d5e:	e9 af fc ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d63:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
80100d68:	31 f6                	xor    %esi,%esi
80100d6a:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d70:	e9 fe fe ff ff       	jmp    80100c73 <exec+0x2d3>
80100d75:	66 90                	xchg   %ax,%ax
80100d77:	66 90                	xchg   %ax,%ax
80100d79:	66 90                	xchg   %ax,%ax
80100d7b:	66 90                	xchg   %ax,%ax
80100d7d:	66 90                	xchg   %ax,%ax
80100d7f:	90                   	nop

80100d80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d86:	c7 44 24 04 bc 6e 10 	movl   $0x80106ebc,0x4(%esp)
80100d8d:	80 
80100d8e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d95:	e8 f6 32 00 00       	call   80104090 <initlock>
}
80100d9a:	c9                   	leave  
80100d9b:	c3                   	ret    
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100da0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da4:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100da9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100dac:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100db3:	e8 c8 33 00 00       	call   80104180 <acquire>
80100db8:	eb 11                	jmp    80100dcb <filealloc+0x2b>
80100dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc0:	83 c3 18             	add    $0x18,%ebx
80100dc3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100dc9:	74 25                	je     80100df0 <filealloc+0x50>
    if(f->ref == 0){
80100dcb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dce:	85 c0                	test   %eax,%eax
80100dd0:	75 ee                	jne    80100dc0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dd2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100dd9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100de0:	e8 8b 34 00 00       	call   80104270 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100de5:	83 c4 14             	add    $0x14,%esp
      return f;
80100de8:	89 d8                	mov    %ebx,%eax
}
80100dea:	5b                   	pop    %ebx
80100deb:	5d                   	pop    %ebp
80100dec:	c3                   	ret    
80100ded:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100df0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df7:	e8 74 34 00 00       	call   80104270 <release>
}
80100dfc:	83 c4 14             	add    $0x14,%esp
  return 0;
80100dff:	31 c0                	xor    %eax,%eax
}
80100e01:	5b                   	pop    %ebx
80100e02:	5d                   	pop    %ebp
80100e03:	c3                   	ret    
80100e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100e10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	53                   	push   %ebx
80100e14:	83 ec 14             	sub    $0x14,%esp
80100e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e1a:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e21:	e8 5a 33 00 00       	call   80104180 <acquire>
  if(f->ref < 1)
80100e26:	8b 43 04             	mov    0x4(%ebx),%eax
80100e29:	85 c0                	test   %eax,%eax
80100e2b:	7e 1a                	jle    80100e47 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e2d:	83 c0 01             	add    $0x1,%eax
80100e30:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e33:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e3a:	e8 31 34 00 00       	call   80104270 <release>
  return f;
}
80100e3f:	83 c4 14             	add    $0x14,%esp
80100e42:	89 d8                	mov    %ebx,%eax
80100e44:	5b                   	pop    %ebx
80100e45:	5d                   	pop    %ebp
80100e46:	c3                   	ret    
    panic("filedup");
80100e47:	c7 04 24 c3 6e 10 80 	movl   $0x80106ec3,(%esp)
80100e4e:	e8 0d f5 ff ff       	call   80100360 <panic>
80100e53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	57                   	push   %edi
80100e64:	56                   	push   %esi
80100e65:	53                   	push   %ebx
80100e66:	83 ec 1c             	sub    $0x1c,%esp
80100e69:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e6c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e73:	e8 08 33 00 00       	call   80104180 <acquire>
  if(f->ref < 1)
80100e78:	8b 57 04             	mov    0x4(%edi),%edx
80100e7b:	85 d2                	test   %edx,%edx
80100e7d:	0f 8e 89 00 00 00    	jle    80100f0c <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e83:	83 ea 01             	sub    $0x1,%edx
80100e86:	85 d2                	test   %edx,%edx
80100e88:	89 57 04             	mov    %edx,0x4(%edi)
80100e8b:	74 13                	je     80100ea0 <fileclose+0x40>
    release(&ftable.lock);
80100e8d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e94:	83 c4 1c             	add    $0x1c,%esp
80100e97:	5b                   	pop    %ebx
80100e98:	5e                   	pop    %esi
80100e99:	5f                   	pop    %edi
80100e9a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e9b:	e9 d0 33 00 00       	jmp    80104270 <release>
  ff = *f;
80100ea0:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100ea4:	8b 37                	mov    (%edi),%esi
80100ea6:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100ea9:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100eaf:	88 45 e7             	mov    %al,-0x19(%ebp)
80100eb2:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100eb5:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100ebc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ebf:	e8 ac 33 00 00       	call   80104270 <release>
  if(ff.type == FD_PIPE)
80100ec4:	83 fe 01             	cmp    $0x1,%esi
80100ec7:	74 0f                	je     80100ed8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100ec9:	83 fe 02             	cmp    $0x2,%esi
80100ecc:	74 22                	je     80100ef0 <fileclose+0x90>
}
80100ece:	83 c4 1c             	add    $0x1c,%esp
80100ed1:	5b                   	pop    %ebx
80100ed2:	5e                   	pop    %esi
80100ed3:	5f                   	pop    %edi
80100ed4:	5d                   	pop    %ebp
80100ed5:	c3                   	ret    
80100ed6:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ed8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100edc:	89 1c 24             	mov    %ebx,(%esp)
80100edf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ee3:	e8 b8 23 00 00       	call   801032a0 <pipeclose>
80100ee8:	eb e4                	jmp    80100ece <fileclose+0x6e>
80100eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ef0:	e8 5b 1c 00 00       	call   80102b50 <begin_op>
    iput(ff.ip);
80100ef5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ef8:	89 04 24             	mov    %eax,(%esp)
80100efb:	e8 10 09 00 00       	call   80101810 <iput>
}
80100f00:	83 c4 1c             	add    $0x1c,%esp
80100f03:	5b                   	pop    %ebx
80100f04:	5e                   	pop    %esi
80100f05:	5f                   	pop    %edi
80100f06:	5d                   	pop    %ebp
    end_op();
80100f07:	e9 b4 1c 00 00       	jmp    80102bc0 <end_op>
    panic("fileclose");
80100f0c:	c7 04 24 cb 6e 10 80 	movl   $0x80106ecb,(%esp)
80100f13:	e8 48 f4 ff ff       	call   80100360 <panic>
80100f18:	90                   	nop
80100f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f20 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	53                   	push   %ebx
80100f24:	83 ec 14             	sub    $0x14,%esp
80100f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f2a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f2d:	75 31                	jne    80100f60 <filestat+0x40>
    ilock(f->ip);
80100f2f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f32:	89 04 24             	mov    %eax,(%esp)
80100f35:	e8 b6 07 00 00       	call   801016f0 <ilock>
    stati(f->ip, st);
80100f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f41:	8b 43 10             	mov    0x10(%ebx),%eax
80100f44:	89 04 24             	mov    %eax,(%esp)
80100f47:	e8 24 0a 00 00       	call   80101970 <stati>
    iunlock(f->ip);
80100f4c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f4f:	89 04 24             	mov    %eax,(%esp)
80100f52:	e8 79 08 00 00       	call   801017d0 <iunlock>
    return 0;
  }
  return -1;
}
80100f57:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f5a:	31 c0                	xor    %eax,%eax
}
80100f5c:	5b                   	pop    %ebx
80100f5d:	5d                   	pop    %ebp
80100f5e:	c3                   	ret    
80100f5f:	90                   	nop
80100f60:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f68:	5b                   	pop    %ebx
80100f69:	5d                   	pop    %ebp
80100f6a:	c3                   	ret    
80100f6b:	90                   	nop
80100f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f70 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	57                   	push   %edi
80100f74:	56                   	push   %esi
80100f75:	53                   	push   %ebx
80100f76:	83 ec 1c             	sub    $0x1c,%esp
80100f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f7f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f82:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f86:	74 68                	je     80100ff0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f88:	8b 03                	mov    (%ebx),%eax
80100f8a:	83 f8 01             	cmp    $0x1,%eax
80100f8d:	74 49                	je     80100fd8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f8f:	83 f8 02             	cmp    $0x2,%eax
80100f92:	75 63                	jne    80100ff7 <fileread+0x87>
    ilock(f->ip);
80100f94:	8b 43 10             	mov    0x10(%ebx),%eax
80100f97:	89 04 24             	mov    %eax,(%esp)
80100f9a:	e8 51 07 00 00       	call   801016f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100fa3:	8b 43 14             	mov    0x14(%ebx),%eax
80100fa6:	89 74 24 04          	mov    %esi,0x4(%esp)
80100faa:	89 44 24 08          	mov    %eax,0x8(%esp)
80100fae:	8b 43 10             	mov    0x10(%ebx),%eax
80100fb1:	89 04 24             	mov    %eax,(%esp)
80100fb4:	e8 e7 09 00 00       	call   801019a0 <readi>
80100fb9:	85 c0                	test   %eax,%eax
80100fbb:	89 c6                	mov    %eax,%esi
80100fbd:	7e 03                	jle    80100fc2 <fileread+0x52>
      f->off += r;
80100fbf:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fc2:	8b 43 10             	mov    0x10(%ebx),%eax
80100fc5:	89 04 24             	mov    %eax,(%esp)
80100fc8:	e8 03 08 00 00       	call   801017d0 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fcd:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100fcf:	83 c4 1c             	add    $0x1c,%esp
80100fd2:	5b                   	pop    %ebx
80100fd3:	5e                   	pop    %esi
80100fd4:	5f                   	pop    %edi
80100fd5:	5d                   	pop    %ebp
80100fd6:	c3                   	ret    
80100fd7:	90                   	nop
    return piperead(f->pipe, addr, n);
80100fd8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fdb:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fde:	83 c4 1c             	add    $0x1c,%esp
80100fe1:	5b                   	pop    %ebx
80100fe2:	5e                   	pop    %esi
80100fe3:	5f                   	pop    %edi
80100fe4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fe5:	e9 36 24 00 00       	jmp    80103420 <piperead>
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ff5:	eb d8                	jmp    80100fcf <fileread+0x5f>
  panic("fileread");
80100ff7:	c7 04 24 d5 6e 10 80 	movl   $0x80106ed5,(%esp)
80100ffe:	e8 5d f3 ff ff       	call   80100360 <panic>
80101003:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101010 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 2c             	sub    $0x2c,%esp
80101019:	8b 45 0c             	mov    0xc(%ebp),%eax
8010101c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010101f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101022:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101025:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80101029:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010102c:	0f 84 ae 00 00 00    	je     801010e0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101032:	8b 07                	mov    (%edi),%eax
80101034:	83 f8 01             	cmp    $0x1,%eax
80101037:	0f 84 c2 00 00 00    	je     801010ff <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103d:	83 f8 02             	cmp    $0x2,%eax
80101040:	0f 85 d7 00 00 00    	jne    8010111d <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101049:	31 db                	xor    %ebx,%ebx
8010104b:	85 c0                	test   %eax,%eax
8010104d:	7f 31                	jg     80101080 <filewrite+0x70>
8010104f:	e9 9c 00 00 00       	jmp    801010f0 <filewrite+0xe0>
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101058:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010105b:	01 47 14             	add    %eax,0x14(%edi)
8010105e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101061:	89 0c 24             	mov    %ecx,(%esp)
80101064:	e8 67 07 00 00       	call   801017d0 <iunlock>
      end_op();
80101069:	e8 52 1b 00 00       	call   80102bc0 <end_op>
8010106e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101071:	39 f0                	cmp    %esi,%eax
80101073:	0f 85 98 00 00 00    	jne    80101111 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101079:	01 c3                	add    %eax,%ebx
    while(i < n){
8010107b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010107e:	7e 70                	jle    801010f0 <filewrite+0xe0>
      int n1 = n - i;
80101080:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101083:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101088:	29 de                	sub    %ebx,%esi
8010108a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101090:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101093:	e8 b8 1a 00 00       	call   80102b50 <begin_op>
      ilock(f->ip);
80101098:	8b 47 10             	mov    0x10(%edi),%eax
8010109b:	89 04 24             	mov    %eax,(%esp)
8010109e:	e8 4d 06 00 00       	call   801016f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010a3:	89 74 24 0c          	mov    %esi,0xc(%esp)
801010a7:	8b 47 14             	mov    0x14(%edi),%eax
801010aa:	89 44 24 08          	mov    %eax,0x8(%esp)
801010ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010b1:	01 d8                	add    %ebx,%eax
801010b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801010b7:	8b 47 10             	mov    0x10(%edi),%eax
801010ba:	89 04 24             	mov    %eax,(%esp)
801010bd:	e8 de 09 00 00       	call   80101aa0 <writei>
801010c2:	85 c0                	test   %eax,%eax
801010c4:	7f 92                	jg     80101058 <filewrite+0x48>
      iunlock(f->ip);
801010c6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010cc:	89 0c 24             	mov    %ecx,(%esp)
801010cf:	e8 fc 06 00 00       	call   801017d0 <iunlock>
      end_op();
801010d4:	e8 e7 1a 00 00       	call   80102bc0 <end_op>
      if(r < 0)
801010d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010dc:	85 c0                	test   %eax,%eax
801010de:	74 91                	je     80101071 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010e0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010e8:	5b                   	pop    %ebx
801010e9:	5e                   	pop    %esi
801010ea:	5f                   	pop    %edi
801010eb:	5d                   	pop    %ebp
801010ec:	c3                   	ret    
801010ed:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010f0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010f3:	89 d8                	mov    %ebx,%eax
801010f5:	75 e9                	jne    801010e0 <filewrite+0xd0>
}
801010f7:	83 c4 2c             	add    $0x2c,%esp
801010fa:	5b                   	pop    %ebx
801010fb:	5e                   	pop    %esi
801010fc:	5f                   	pop    %edi
801010fd:	5d                   	pop    %ebp
801010fe:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010ff:	8b 47 0c             	mov    0xc(%edi),%eax
80101102:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101105:	83 c4 2c             	add    $0x2c,%esp
80101108:	5b                   	pop    %ebx
80101109:	5e                   	pop    %esi
8010110a:	5f                   	pop    %edi
8010110b:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010110c:	e9 1f 22 00 00       	jmp    80103330 <pipewrite>
        panic("short filewrite");
80101111:	c7 04 24 de 6e 10 80 	movl   $0x80106ede,(%esp)
80101118:	e8 43 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
8010111d:	c7 04 24 e4 6e 10 80 	movl   $0x80106ee4,(%esp)
80101124:	e8 37 f2 ff ff       	call   80100360 <panic>
80101129:	66 90                	xchg   %ax,%ax
8010112b:	66 90                	xchg   %ax,%ax
8010112d:	66 90                	xchg   %ax,%ax
8010112f:	90                   	nop

80101130 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	57                   	push   %edi
80101134:	56                   	push   %esi
80101135:	53                   	push   %ebx
80101136:	83 ec 2c             	sub    $0x2c,%esp
80101139:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010113c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101141:	85 c0                	test   %eax,%eax
80101143:	0f 84 8c 00 00 00    	je     801011d5 <balloc+0xa5>
80101149:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101150:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101153:	89 f0                	mov    %esi,%eax
80101155:	c1 f8 0c             	sar    $0xc,%eax
80101158:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010115e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101162:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101165:	89 04 24             	mov    %eax,(%esp)
80101168:	e8 63 ef ff ff       	call   801000d0 <bread>
8010116d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101170:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101175:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101178:	31 c0                	xor    %eax,%eax
8010117a:	eb 33                	jmp    801011af <balloc+0x7f>
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101180:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101183:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
80101185:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101187:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
8010118a:	83 e1 07             	and    $0x7,%ecx
8010118d:	bf 01 00 00 00       	mov    $0x1,%edi
80101192:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101194:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
80101199:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010119b:	0f b6 fb             	movzbl %bl,%edi
8010119e:	85 cf                	test   %ecx,%edi
801011a0:	74 46                	je     801011e8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011a2:	83 c0 01             	add    $0x1,%eax
801011a5:	83 c6 01             	add    $0x1,%esi
801011a8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011ad:	74 05                	je     801011b4 <balloc+0x84>
801011af:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011b2:	72 cc                	jb     80101180 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011b7:	89 04 24             	mov    %eax,(%esp)
801011ba:	e8 21 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801011bf:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011c9:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
801011cf:	0f 82 7b ff ff ff    	jb     80101150 <balloc+0x20>
  }
  panic("balloc: out of blocks");
801011d5:	c7 04 24 ee 6e 10 80 	movl   $0x80106eee,(%esp)
801011dc:	e8 7f f1 ff ff       	call   80100360 <panic>
801011e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801011e8:	09 d9                	or     %ebx,%ecx
801011ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011ed:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011f1:	89 1c 24             	mov    %ebx,(%esp)
801011f4:	e8 f7 1a 00 00       	call   80102cf0 <log_write>
        brelse(bp);
801011f9:	89 1c 24             	mov    %ebx,(%esp)
801011fc:	e8 df ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
80101201:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101204:	89 74 24 04          	mov    %esi,0x4(%esp)
80101208:	89 04 24             	mov    %eax,(%esp)
8010120b:	e8 c0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101210:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101217:	00 
80101218:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010121f:	00 
  bp = bread(dev, bno);
80101220:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101222:	8d 40 5c             	lea    0x5c(%eax),%eax
80101225:	89 04 24             	mov    %eax,(%esp)
80101228:	e8 93 30 00 00       	call   801042c0 <memset>
  log_write(bp);
8010122d:	89 1c 24             	mov    %ebx,(%esp)
80101230:	e8 bb 1a 00 00       	call   80102cf0 <log_write>
  brelse(bp);
80101235:	89 1c 24             	mov    %ebx,(%esp)
80101238:	e8 a3 ef ff ff       	call   801001e0 <brelse>
}
8010123d:	83 c4 2c             	add    $0x2c,%esp
80101240:	89 f0                	mov    %esi,%eax
80101242:	5b                   	pop    %ebx
80101243:	5e                   	pop    %esi
80101244:	5f                   	pop    %edi
80101245:	5d                   	pop    %ebp
80101246:	c3                   	ret    
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101250 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	89 c7                	mov    %eax,%edi
80101256:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101257:	31 f6                	xor    %esi,%esi
{
80101259:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010125f:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
80101262:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
80101269:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010126c:	e8 0f 2f 00 00       	call   80104180 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101271:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101274:	eb 14                	jmp    8010128a <iget+0x3a>
80101276:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101278:	85 f6                	test   %esi,%esi
8010127a:	74 3c                	je     801012b8 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010127c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101282:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101288:	74 46                	je     801012d0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010128a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010128d:	85 c9                	test   %ecx,%ecx
8010128f:	7e e7                	jle    80101278 <iget+0x28>
80101291:	39 3b                	cmp    %edi,(%ebx)
80101293:	75 e3                	jne    80101278 <iget+0x28>
80101295:	39 53 04             	cmp    %edx,0x4(%ebx)
80101298:	75 de                	jne    80101278 <iget+0x28>
      ip->ref++;
8010129a:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010129d:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010129f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
801012a6:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012a9:	e8 c2 2f 00 00       	call   80104270 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012ae:	83 c4 1c             	add    $0x1c,%esp
801012b1:	89 f0                	mov    %esi,%eax
801012b3:	5b                   	pop    %ebx
801012b4:	5e                   	pop    %esi
801012b5:	5f                   	pop    %edi
801012b6:	5d                   	pop    %ebp
801012b7:	c3                   	ret    
801012b8:	85 c9                	test   %ecx,%ecx
801012ba:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012bd:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c3:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012c9:	75 bf                	jne    8010128a <iget+0x3a>
801012cb:	90                   	nop
801012cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
801012d0:	85 f6                	test   %esi,%esi
801012d2:	74 29                	je     801012fd <iget+0xad>
  ip->dev = dev;
801012d4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012d6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012d9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012e0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012e7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012ee:	e8 7d 2f 00 00       	call   80104270 <release>
}
801012f3:	83 c4 1c             	add    $0x1c,%esp
801012f6:	89 f0                	mov    %esi,%eax
801012f8:	5b                   	pop    %ebx
801012f9:	5e                   	pop    %esi
801012fa:	5f                   	pop    %edi
801012fb:	5d                   	pop    %ebp
801012fc:	c3                   	ret    
    panic("iget: no inodes");
801012fd:	c7 04 24 04 6f 10 80 	movl   $0x80106f04,(%esp)
80101304:	e8 57 f0 ff ff       	call   80100360 <panic>
80101309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101310 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	57                   	push   %edi
80101314:	56                   	push   %esi
80101315:	53                   	push   %ebx
80101316:	89 c3                	mov    %eax,%ebx
80101318:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010131b:	83 fa 0b             	cmp    $0xb,%edx
8010131e:	77 18                	ja     80101338 <bmap+0x28>
80101320:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101323:	8b 46 5c             	mov    0x5c(%esi),%eax
80101326:	85 c0                	test   %eax,%eax
80101328:	74 66                	je     80101390 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010132a:	83 c4 1c             	add    $0x1c,%esp
8010132d:	5b                   	pop    %ebx
8010132e:	5e                   	pop    %esi
8010132f:	5f                   	pop    %edi
80101330:	5d                   	pop    %ebp
80101331:	c3                   	ret    
80101332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
80101338:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
8010133b:	83 fe 7f             	cmp    $0x7f,%esi
8010133e:	77 77                	ja     801013b7 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101340:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101346:	85 c0                	test   %eax,%eax
80101348:	74 5e                	je     801013a8 <bmap+0x98>
    bp = bread(ip->dev, addr);
8010134a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010134e:	8b 03                	mov    (%ebx),%eax
80101350:	89 04 24             	mov    %eax,(%esp)
80101353:	e8 78 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101358:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
8010135c:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010135e:	8b 32                	mov    (%edx),%esi
80101360:	85 f6                	test   %esi,%esi
80101362:	75 19                	jne    8010137d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101364:	8b 03                	mov    (%ebx),%eax
80101366:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101369:	e8 c2 fd ff ff       	call   80101130 <balloc>
8010136e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101371:	89 02                	mov    %eax,(%edx)
80101373:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101375:	89 3c 24             	mov    %edi,(%esp)
80101378:	e8 73 19 00 00       	call   80102cf0 <log_write>
    brelse(bp);
8010137d:	89 3c 24             	mov    %edi,(%esp)
80101380:	e8 5b ee ff ff       	call   801001e0 <brelse>
}
80101385:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
80101388:	89 f0                	mov    %esi,%eax
}
8010138a:	5b                   	pop    %ebx
8010138b:	5e                   	pop    %esi
8010138c:	5f                   	pop    %edi
8010138d:	5d                   	pop    %ebp
8010138e:	c3                   	ret    
8010138f:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
80101390:	8b 03                	mov    (%ebx),%eax
80101392:	e8 99 fd ff ff       	call   80101130 <balloc>
80101397:	89 46 5c             	mov    %eax,0x5c(%esi)
}
8010139a:	83 c4 1c             	add    $0x1c,%esp
8010139d:	5b                   	pop    %ebx
8010139e:	5e                   	pop    %esi
8010139f:	5f                   	pop    %edi
801013a0:	5d                   	pop    %ebp
801013a1:	c3                   	ret    
801013a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a8:	8b 03                	mov    (%ebx),%eax
801013aa:	e8 81 fd ff ff       	call   80101130 <balloc>
801013af:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801013b5:	eb 93                	jmp    8010134a <bmap+0x3a>
  panic("bmap: out of range");
801013b7:	c7 04 24 14 6f 10 80 	movl   $0x80106f14,(%esp)
801013be:	e8 9d ef ff ff       	call   80100360 <panic>
801013c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
801013d8:	8b 45 08             	mov    0x8(%ebp),%eax
801013db:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013e2:	00 
{
801013e3:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013e6:	89 04 24             	mov    %eax,(%esp)
801013e9:	e8 e2 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013ee:	89 34 24             	mov    %esi,(%esp)
801013f1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013f8:	00 
  bp = bread(dev, 1);
801013f9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013fb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80101402:	e8 59 2f 00 00       	call   80104360 <memmove>
  brelse(bp);
80101407:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010140a:	83 c4 10             	add    $0x10,%esp
8010140d:	5b                   	pop    %ebx
8010140e:	5e                   	pop    %esi
8010140f:	5d                   	pop    %ebp
  brelse(bp);
80101410:	e9 cb ed ff ff       	jmp    801001e0 <brelse>
80101415:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101420 <bfree>:
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	57                   	push   %edi
80101424:	89 d7                	mov    %edx,%edi
80101426:	56                   	push   %esi
80101427:	53                   	push   %ebx
80101428:	89 c3                	mov    %eax,%ebx
8010142a:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
8010142d:	89 04 24             	mov    %eax,(%esp)
80101430:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101437:	80 
80101438:	e8 93 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010143d:	89 fa                	mov    %edi,%edx
8010143f:	c1 ea 0c             	shr    $0xc,%edx
80101442:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101448:	89 1c 24             	mov    %ebx,(%esp)
  m = 1 << (bi % 8);
8010144b:	bb 01 00 00 00       	mov    $0x1,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101450:	89 54 24 04          	mov    %edx,0x4(%esp)
80101454:	e8 77 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101459:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
8010145b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101461:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101463:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101466:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101469:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
8010146b:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
8010146d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101472:	0f b6 c8             	movzbl %al,%ecx
80101475:	85 d9                	test   %ebx,%ecx
80101477:	74 20                	je     80101499 <bfree+0x79>
  bp->data[bi/8] &= ~m;
80101479:	f7 d3                	not    %ebx
8010147b:	21 c3                	and    %eax,%ebx
8010147d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101481:	89 34 24             	mov    %esi,(%esp)
80101484:	e8 67 18 00 00       	call   80102cf0 <log_write>
  brelse(bp);
80101489:	89 34 24             	mov    %esi,(%esp)
8010148c:	e8 4f ed ff ff       	call   801001e0 <brelse>
}
80101491:	83 c4 1c             	add    $0x1c,%esp
80101494:	5b                   	pop    %ebx
80101495:	5e                   	pop    %esi
80101496:	5f                   	pop    %edi
80101497:	5d                   	pop    %ebp
80101498:	c3                   	ret    
    panic("freeing free block");
80101499:	c7 04 24 27 6f 10 80 	movl   $0x80106f27,(%esp)
801014a0:	e8 bb ee ff ff       	call   80100360 <panic>
801014a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014b0 <iinit>:
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	53                   	push   %ebx
801014b4:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801014b9:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
801014bc:	c7 44 24 04 3a 6f 10 	movl   $0x80106f3a,0x4(%esp)
801014c3:	80 
801014c4:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801014cb:	e8 c0 2b 00 00       	call   80104090 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
801014d0:	89 1c 24             	mov    %ebx,(%esp)
801014d3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014d9:	c7 44 24 04 41 6f 10 	movl   $0x80106f41,0x4(%esp)
801014e0:	80 
801014e1:	e8 9a 2a 00 00       	call   80103f80 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014e6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014ec:	75 e2                	jne    801014d0 <iinit+0x20>
  readsb(dev, &sb);
801014ee:	8b 45 08             	mov    0x8(%ebp),%eax
801014f1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014f8:	80 
801014f9:	89 04 24             	mov    %eax,(%esp)
801014fc:	e8 cf fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101501:	a1 d8 09 11 80       	mov    0x801109d8,%eax
80101506:	c7 04 24 a4 6f 10 80 	movl   $0x80106fa4,(%esp)
8010150d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101511:	a1 d4 09 11 80       	mov    0x801109d4,%eax
80101516:	89 44 24 18          	mov    %eax,0x18(%esp)
8010151a:	a1 d0 09 11 80       	mov    0x801109d0,%eax
8010151f:	89 44 24 14          	mov    %eax,0x14(%esp)
80101523:	a1 cc 09 11 80       	mov    0x801109cc,%eax
80101528:	89 44 24 10          	mov    %eax,0x10(%esp)
8010152c:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101531:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101535:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010153a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010153e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101543:	89 44 24 04          	mov    %eax,0x4(%esp)
80101547:	e8 04 f1 ff ff       	call   80100650 <cprintf>
}
8010154c:	83 c4 24             	add    $0x24,%esp
8010154f:	5b                   	pop    %ebx
80101550:	5d                   	pop    %ebp
80101551:	c3                   	ret    
80101552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101560 <ialloc>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	57                   	push   %edi
80101564:	56                   	push   %esi
80101565:	53                   	push   %ebx
80101566:	83 ec 2c             	sub    $0x2c,%esp
80101569:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010156c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101573:	8b 7d 08             	mov    0x8(%ebp),%edi
80101576:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101579:	0f 86 a2 00 00 00    	jbe    80101621 <ialloc+0xc1>
8010157f:	be 01 00 00 00       	mov    $0x1,%esi
80101584:	bb 01 00 00 00       	mov    $0x1,%ebx
80101589:	eb 1a                	jmp    801015a5 <ialloc+0x45>
8010158b:	90                   	nop
8010158c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101590:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101593:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101596:	e8 45 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010159b:	89 de                	mov    %ebx,%esi
8010159d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
801015a3:	73 7c                	jae    80101621 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
801015a5:	89 f0                	mov    %esi,%eax
801015a7:	c1 e8 03             	shr    $0x3,%eax
801015aa:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015b0:	89 3c 24             	mov    %edi,(%esp)
801015b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801015b7:	e8 14 eb ff ff       	call   801000d0 <bread>
801015bc:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
801015be:	89 f0                	mov    %esi,%eax
801015c0:	83 e0 07             	and    $0x7,%eax
801015c3:	c1 e0 06             	shl    $0x6,%eax
801015c6:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ca:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015ce:	75 c0                	jne    80101590 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015d0:	89 0c 24             	mov    %ecx,(%esp)
801015d3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015da:	00 
801015db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015e2:	00 
801015e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015e9:	e8 d2 2c 00 00       	call   801042c0 <memset>
      dip->type = type;
801015ee:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015f5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015f8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015fb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015fe:	89 14 24             	mov    %edx,(%esp)
80101601:	e8 ea 16 00 00       	call   80102cf0 <log_write>
      brelse(bp);
80101606:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101609:	89 14 24             	mov    %edx,(%esp)
8010160c:	e8 cf eb ff ff       	call   801001e0 <brelse>
}
80101611:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
80101614:	89 f2                	mov    %esi,%edx
}
80101616:	5b                   	pop    %ebx
      return iget(dev, inum);
80101617:	89 f8                	mov    %edi,%eax
}
80101619:	5e                   	pop    %esi
8010161a:	5f                   	pop    %edi
8010161b:	5d                   	pop    %ebp
      return iget(dev, inum);
8010161c:	e9 2f fc ff ff       	jmp    80101250 <iget>
  panic("ialloc: no inodes");
80101621:	c7 04 24 47 6f 10 80 	movl   $0x80106f47,(%esp)
80101628:	e8 33 ed ff ff       	call   80100360 <panic>
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <iupdate>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	56                   	push   %esi
80101634:	53                   	push   %ebx
80101635:	83 ec 10             	sub    $0x10,%esp
80101638:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010163b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101641:	c1 e8 03             	shr    $0x3,%eax
80101644:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010164a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010164e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101651:	89 04 24             	mov    %eax,(%esp)
80101654:	e8 77 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101659:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010165c:	83 e2 07             	and    $0x7,%edx
8010165f:	c1 e2 06             	shl    $0x6,%edx
80101662:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101666:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101668:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010166f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101673:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101677:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010167b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010167f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101683:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101687:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010168b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010168e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101691:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101695:	89 14 24             	mov    %edx,(%esp)
80101698:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010169f:	00 
801016a0:	e8 bb 2c 00 00       	call   80104360 <memmove>
  log_write(bp);
801016a5:	89 34 24             	mov    %esi,(%esp)
801016a8:	e8 43 16 00 00       	call   80102cf0 <log_write>
  brelse(bp);
801016ad:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016b0:	83 c4 10             	add    $0x10,%esp
801016b3:	5b                   	pop    %ebx
801016b4:	5e                   	pop    %esi
801016b5:	5d                   	pop    %ebp
  brelse(bp);
801016b6:	e9 25 eb ff ff       	jmp    801001e0 <brelse>
801016bb:	90                   	nop
801016bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016c0 <idup>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	53                   	push   %ebx
801016c4:	83 ec 14             	sub    $0x14,%esp
801016c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ca:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016d1:	e8 aa 2a 00 00       	call   80104180 <acquire>
  ip->ref++;
801016d6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016da:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016e1:	e8 8a 2b 00 00       	call   80104270 <release>
}
801016e6:	83 c4 14             	add    $0x14,%esp
801016e9:	89 d8                	mov    %ebx,%eax
801016eb:	5b                   	pop    %ebx
801016ec:	5d                   	pop    %ebp
801016ed:	c3                   	ret    
801016ee:	66 90                	xchg   %ax,%ax

801016f0 <ilock>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	83 ec 10             	sub    $0x10,%esp
801016f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016fb:	85 db                	test   %ebx,%ebx
801016fd:	0f 84 b3 00 00 00    	je     801017b6 <ilock+0xc6>
80101703:	8b 53 08             	mov    0x8(%ebx),%edx
80101706:	85 d2                	test   %edx,%edx
80101708:	0f 8e a8 00 00 00    	jle    801017b6 <ilock+0xc6>
  acquiresleep(&ip->lock);
8010170e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101711:	89 04 24             	mov    %eax,(%esp)
80101714:	e8 a7 28 00 00       	call   80103fc0 <acquiresleep>
  if(ip->valid == 0){
80101719:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010171c:	85 c0                	test   %eax,%eax
8010171e:	74 08                	je     80101728 <ilock+0x38>
}
80101720:	83 c4 10             	add    $0x10,%esp
80101723:	5b                   	pop    %ebx
80101724:	5e                   	pop    %esi
80101725:	5d                   	pop    %ebp
80101726:	c3                   	ret    
80101727:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101728:	8b 43 04             	mov    0x4(%ebx),%eax
8010172b:	c1 e8 03             	shr    $0x3,%eax
8010172e:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101734:	89 44 24 04          	mov    %eax,0x4(%esp)
80101738:	8b 03                	mov    (%ebx),%eax
8010173a:	89 04 24             	mov    %eax,(%esp)
8010173d:	e8 8e e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101742:	8b 53 04             	mov    0x4(%ebx),%edx
80101745:	83 e2 07             	and    $0x7,%edx
80101748:	c1 e2 06             	shl    $0x6,%edx
8010174b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174f:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101751:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101754:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101757:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010175b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010175f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101763:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101767:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010176b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010176f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101773:	8b 42 fc             	mov    -0x4(%edx),%eax
80101776:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101779:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010177c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101780:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101787:	00 
80101788:	89 04 24             	mov    %eax,(%esp)
8010178b:	e8 d0 2b 00 00       	call   80104360 <memmove>
    brelse(bp);
80101790:	89 34 24             	mov    %esi,(%esp)
80101793:	e8 48 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101798:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010179d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017a4:	0f 85 76 ff ff ff    	jne    80101720 <ilock+0x30>
      panic("ilock: no type");
801017aa:	c7 04 24 5f 6f 10 80 	movl   $0x80106f5f,(%esp)
801017b1:	e8 aa eb ff ff       	call   80100360 <panic>
    panic("ilock");
801017b6:	c7 04 24 59 6f 10 80 	movl   $0x80106f59,(%esp)
801017bd:	e8 9e eb ff ff       	call   80100360 <panic>
801017c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017d0 <iunlock>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	56                   	push   %esi
801017d4:	53                   	push   %ebx
801017d5:	83 ec 10             	sub    $0x10,%esp
801017d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017db:	85 db                	test   %ebx,%ebx
801017dd:	74 24                	je     80101803 <iunlock+0x33>
801017df:	8d 73 0c             	lea    0xc(%ebx),%esi
801017e2:	89 34 24             	mov    %esi,(%esp)
801017e5:	e8 76 28 00 00       	call   80104060 <holdingsleep>
801017ea:	85 c0                	test   %eax,%eax
801017ec:	74 15                	je     80101803 <iunlock+0x33>
801017ee:	8b 43 08             	mov    0x8(%ebx),%eax
801017f1:	85 c0                	test   %eax,%eax
801017f3:	7e 0e                	jle    80101803 <iunlock+0x33>
  releasesleep(&ip->lock);
801017f5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017f8:	83 c4 10             	add    $0x10,%esp
801017fb:	5b                   	pop    %ebx
801017fc:	5e                   	pop    %esi
801017fd:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017fe:	e9 1d 28 00 00       	jmp    80104020 <releasesleep>
    panic("iunlock");
80101803:	c7 04 24 6e 6f 10 80 	movl   $0x80106f6e,(%esp)
8010180a:	e8 51 eb ff ff       	call   80100360 <panic>
8010180f:	90                   	nop

80101810 <iput>:
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	57                   	push   %edi
80101814:	56                   	push   %esi
80101815:	53                   	push   %ebx
80101816:	83 ec 1c             	sub    $0x1c,%esp
80101819:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010181c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010181f:	89 3c 24             	mov    %edi,(%esp)
80101822:	e8 99 27 00 00       	call   80103fc0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101827:	8b 56 4c             	mov    0x4c(%esi),%edx
8010182a:	85 d2                	test   %edx,%edx
8010182c:	74 07                	je     80101835 <iput+0x25>
8010182e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101833:	74 2b                	je     80101860 <iput+0x50>
  releasesleep(&ip->lock);
80101835:	89 3c 24             	mov    %edi,(%esp)
80101838:	e8 e3 27 00 00       	call   80104020 <releasesleep>
  acquire(&icache.lock);
8010183d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101844:	e8 37 29 00 00       	call   80104180 <acquire>
  ip->ref--;
80101849:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010184d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101854:	83 c4 1c             	add    $0x1c,%esp
80101857:	5b                   	pop    %ebx
80101858:	5e                   	pop    %esi
80101859:	5f                   	pop    %edi
8010185a:	5d                   	pop    %ebp
  release(&icache.lock);
8010185b:	e9 10 2a 00 00       	jmp    80104270 <release>
    acquire(&icache.lock);
80101860:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101867:	e8 14 29 00 00       	call   80104180 <acquire>
    int r = ip->ref;
8010186c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010186f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101876:	e8 f5 29 00 00       	call   80104270 <release>
    if(r == 1){
8010187b:	83 fb 01             	cmp    $0x1,%ebx
8010187e:	75 b5                	jne    80101835 <iput+0x25>
80101880:	8d 4e 30             	lea    0x30(%esi),%ecx
80101883:	89 f3                	mov    %esi,%ebx
80101885:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101888:	89 cf                	mov    %ecx,%edi
8010188a:	eb 0b                	jmp    80101897 <iput+0x87>
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101890:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101893:	39 fb                	cmp    %edi,%ebx
80101895:	74 19                	je     801018b0 <iput+0xa0>
    if(ip->addrs[i]){
80101897:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010189a:	85 d2                	test   %edx,%edx
8010189c:	74 f2                	je     80101890 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010189e:	8b 06                	mov    (%esi),%eax
801018a0:	e8 7b fb ff ff       	call   80101420 <bfree>
      ip->addrs[i] = 0;
801018a5:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
801018ac:	eb e2                	jmp    80101890 <iput+0x80>
801018ae:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
801018b0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801018b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018b9:	85 c0                	test   %eax,%eax
801018bb:	75 2b                	jne    801018e8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018bd:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018c4:	89 34 24             	mov    %esi,(%esp)
801018c7:	e8 64 fd ff ff       	call   80101630 <iupdate>
      ip->type = 0;
801018cc:	31 c0                	xor    %eax,%eax
801018ce:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018d2:	89 34 24             	mov    %esi,(%esp)
801018d5:	e8 56 fd ff ff       	call   80101630 <iupdate>
      ip->valid = 0;
801018da:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018e1:	e9 4f ff ff ff       	jmp    80101835 <iput+0x25>
801018e6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018ec:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
801018ee:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018f0:	89 04 24             	mov    %eax,(%esp)
801018f3:	e8 d8 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018f8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018fb:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101901:	89 cf                	mov    %ecx,%edi
80101903:	31 c0                	xor    %eax,%eax
80101905:	eb 0e                	jmp    80101915 <iput+0x105>
80101907:	90                   	nop
80101908:	83 c3 01             	add    $0x1,%ebx
8010190b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101911:	89 d8                	mov    %ebx,%eax
80101913:	74 10                	je     80101925 <iput+0x115>
      if(a[j])
80101915:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101918:	85 d2                	test   %edx,%edx
8010191a:	74 ec                	je     80101908 <iput+0xf8>
        bfree(ip->dev, a[j]);
8010191c:	8b 06                	mov    (%esi),%eax
8010191e:	e8 fd fa ff ff       	call   80101420 <bfree>
80101923:	eb e3                	jmp    80101908 <iput+0xf8>
    brelse(bp);
80101925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101928:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010192b:	89 04 24             	mov    %eax,(%esp)
8010192e:	e8 ad e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101933:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101939:	8b 06                	mov    (%esi),%eax
8010193b:	e8 e0 fa ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT] = 0;
80101940:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101947:	00 00 00 
8010194a:	e9 6e ff ff ff       	jmp    801018bd <iput+0xad>
8010194f:	90                   	nop

80101950 <iunlockput>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	53                   	push   %ebx
80101954:	83 ec 14             	sub    $0x14,%esp
80101957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010195a:	89 1c 24             	mov    %ebx,(%esp)
8010195d:	e8 6e fe ff ff       	call   801017d0 <iunlock>
  iput(ip);
80101962:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101965:	83 c4 14             	add    $0x14,%esp
80101968:	5b                   	pop    %ebx
80101969:	5d                   	pop    %ebp
  iput(ip);
8010196a:	e9 a1 fe ff ff       	jmp    80101810 <iput>
8010196f:	90                   	nop

80101970 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	8b 55 08             	mov    0x8(%ebp),%edx
80101976:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101979:	8b 0a                	mov    (%edx),%ecx
8010197b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010197e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101981:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101984:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101988:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010198b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010198f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101993:	8b 52 58             	mov    0x58(%edx),%edx
80101996:	89 50 10             	mov    %edx,0x10(%eax)
}
80101999:	5d                   	pop    %ebp
8010199a:	c3                   	ret    
8010199b:	90                   	nop
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019a0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 2c             	sub    $0x2c,%esp
801019a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801019ac:	8b 7d 08             	mov    0x8(%ebp),%edi
801019af:	8b 75 10             	mov    0x10(%ebp),%esi
801019b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019b5:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019b8:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
801019bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019c0:	0f 84 aa 00 00 00    	je     80101a70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019c6:	8b 47 58             	mov    0x58(%edi),%eax
801019c9:	39 f0                	cmp    %esi,%eax
801019cb:	0f 82 c7 00 00 00    	jb     80101a98 <readi+0xf8>
801019d1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019d4:	89 da                	mov    %ebx,%edx
801019d6:	01 f2                	add    %esi,%edx
801019d8:	0f 82 ba 00 00 00    	jb     80101a98 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019de:	89 c1                	mov    %eax,%ecx
801019e0:	29 f1                	sub    %esi,%ecx
801019e2:	39 d0                	cmp    %edx,%eax
801019e4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e7:	31 c0                	xor    %eax,%eax
801019e9:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
801019eb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ee:	74 70                	je     80101a60 <readi+0xc0>
801019f0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019f3:	89 c7                	mov    %eax,%edi
801019f5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019f8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019fb:	89 f2                	mov    %esi,%edx
801019fd:	c1 ea 09             	shr    $0x9,%edx
80101a00:	89 d8                	mov    %ebx,%eax
80101a02:	e8 09 f9 ff ff       	call   80101310 <bmap>
80101a07:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a0b:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0d:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a12:	89 04 24             	mov    %eax,(%esp)
80101a15:	e8 b6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a1d:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a1f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a21:	89 f0                	mov    %esi,%eax
80101a23:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a28:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a2a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a2e:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a30:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a37:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a3a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a3e:	01 df                	add    %ebx,%edi
80101a40:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a42:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a45:	89 04 24             	mov    %eax,(%esp)
80101a48:	e8 13 29 00 00       	call   80104360 <memmove>
    brelse(bp);
80101a4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a50:	89 14 24             	mov    %edx,(%esp)
80101a53:	e8 88 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a58:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a5b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a5e:	77 98                	ja     801019f8 <readi+0x58>
  }
  return n;
80101a60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a63:	83 c4 2c             	add    $0x2c,%esp
80101a66:	5b                   	pop    %ebx
80101a67:	5e                   	pop    %esi
80101a68:	5f                   	pop    %edi
80101a69:	5d                   	pop    %ebp
80101a6a:	c3                   	ret    
80101a6b:	90                   	nop
80101a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a70:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a74:	66 83 f8 09          	cmp    $0x9,%ax
80101a78:	77 1e                	ja     80101a98 <readi+0xf8>
80101a7a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a81:	85 c0                	test   %eax,%eax
80101a83:	74 13                	je     80101a98 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a85:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a88:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a8b:	83 c4 2c             	add    $0x2c,%esp
80101a8e:	5b                   	pop    %ebx
80101a8f:	5e                   	pop    %esi
80101a90:	5f                   	pop    %edi
80101a91:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a92:	ff e0                	jmp    *%eax
80101a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a9d:	eb c4                	jmp    80101a63 <readi+0xc3>
80101a9f:	90                   	nop

80101aa0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 2c             	sub    $0x2c,%esp
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aaf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ab7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aba:	8b 75 10             	mov    0x10(%ebp),%esi
80101abd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ac0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 b7 00 00 00    	je     80101b80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	39 70 58             	cmp    %esi,0x58(%eax)
80101acf:	0f 82 e3 00 00 00    	jb     80101bb8 <writei+0x118>
80101ad5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ad8:	89 c8                	mov    %ecx,%eax
80101ada:	01 f0                	add    %esi,%eax
80101adc:	0f 82 d6 00 00 00    	jb     80101bb8 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ae2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ae7:	0f 87 cb 00 00 00    	ja     80101bb8 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101aed:	85 c9                	test   %ecx,%ecx
80101aef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101af6:	74 77                	je     80101b6f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101afb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101afd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b02:	c1 ea 09             	shr    $0x9,%edx
80101b05:	89 f8                	mov    %edi,%eax
80101b07:	e8 04 f8 ff ff       	call   80101310 <bmap>
80101b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b10:	8b 07                	mov    (%edi),%eax
80101b12:	89 04 24             	mov    %eax,(%esp)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b1d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b20:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b23:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b25:	89 f0                	mov    %esi,%eax
80101b27:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b2c:	29 c3                	sub    %eax,%ebx
80101b2e:	39 cb                	cmp    %ecx,%ebx
80101b30:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b37:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b39:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b3d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b41:	89 04 24             	mov    %eax,(%esp)
80101b44:	e8 17 28 00 00       	call   80104360 <memmove>
    log_write(bp);
80101b49:	89 3c 24             	mov    %edi,(%esp)
80101b4c:	e8 9f 11 00 00       	call   80102cf0 <log_write>
    brelse(bp);
80101b51:	89 3c 24             	mov    %edi,(%esp)
80101b54:	e8 87 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b59:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b5f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b62:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b65:	77 91                	ja     80101af8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b67:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b6d:	72 39                	jb     80101ba8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b72:	83 c4 2c             	add    $0x2c,%esp
80101b75:	5b                   	pop    %ebx
80101b76:	5e                   	pop    %esi
80101b77:	5f                   	pop    %edi
80101b78:	5d                   	pop    %ebp
80101b79:	c3                   	ret    
80101b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 2e                	ja     80101bb8 <writei+0x118>
80101b8a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 23                	je     80101bb8 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b95:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b98:	83 c4 2c             	add    $0x2c,%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b9f:	ff e0                	jmp    *%eax
80101ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ba8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bab:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bae:	89 04 24             	mov    %eax,(%esp)
80101bb1:	e8 7a fa ff ff       	call   80101630 <iupdate>
80101bb6:	eb b7                	jmp    80101b6f <writei+0xcf>
}
80101bb8:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101bbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101bc0:	5b                   	pop    %ebx
80101bc1:	5e                   	pop    %esi
80101bc2:	5f                   	pop    %edi
80101bc3:	5d                   	pop    %ebp
80101bc4:	c3                   	ret    
80101bc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bd9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101be0:	00 
80101be1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101be5:	8b 45 08             	mov    0x8(%ebp),%eax
80101be8:	89 04 24             	mov    %eax,(%esp)
80101beb:	e8 f0 27 00 00       	call   801043e0 <strncmp>
}
80101bf0:	c9                   	leave  
80101bf1:	c3                   	ret    
80101bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c00 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 2c             	sub    $0x2c,%esp
80101c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c0c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c11:	0f 85 97 00 00 00    	jne    80101cae <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c17:	8b 53 58             	mov    0x58(%ebx),%edx
80101c1a:	31 ff                	xor    %edi,%edi
80101c1c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c1f:	85 d2                	test   %edx,%edx
80101c21:	75 0d                	jne    80101c30 <dirlookup+0x30>
80101c23:	eb 73                	jmp    80101c98 <dirlookup+0x98>
80101c25:	8d 76 00             	lea    0x0(%esi),%esi
80101c28:	83 c7 10             	add    $0x10,%edi
80101c2b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c2e:	76 68                	jbe    80101c98 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c30:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c37:	00 
80101c38:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c3c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c40:	89 1c 24             	mov    %ebx,(%esp)
80101c43:	e8 58 fd ff ff       	call   801019a0 <readi>
80101c48:	83 f8 10             	cmp    $0x10,%eax
80101c4b:	75 55                	jne    80101ca2 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c4d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c52:	74 d4                	je     80101c28 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c54:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c57:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c5e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c65:	00 
80101c66:	89 04 24             	mov    %eax,(%esp)
80101c69:	e8 72 27 00 00       	call   801043e0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c6e:	85 c0                	test   %eax,%eax
80101c70:	75 b6                	jne    80101c28 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c72:	8b 45 10             	mov    0x10(%ebp),%eax
80101c75:	85 c0                	test   %eax,%eax
80101c77:	74 05                	je     80101c7e <dirlookup+0x7e>
        *poff = off;
80101c79:	8b 45 10             	mov    0x10(%ebp),%eax
80101c7c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c7e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c82:	8b 03                	mov    (%ebx),%eax
80101c84:	e8 c7 f5 ff ff       	call   80101250 <iget>
    }
  }

  return 0;
}
80101c89:	83 c4 2c             	add    $0x2c,%esp
80101c8c:	5b                   	pop    %ebx
80101c8d:	5e                   	pop    %esi
80101c8e:	5f                   	pop    %edi
80101c8f:	5d                   	pop    %ebp
80101c90:	c3                   	ret    
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c98:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c9b:	31 c0                	xor    %eax,%eax
}
80101c9d:	5b                   	pop    %ebx
80101c9e:	5e                   	pop    %esi
80101c9f:	5f                   	pop    %edi
80101ca0:	5d                   	pop    %ebp
80101ca1:	c3                   	ret    
      panic("dirlookup read");
80101ca2:	c7 04 24 88 6f 10 80 	movl   $0x80106f88,(%esp)
80101ca9:	e8 b2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101cae:	c7 04 24 76 6f 10 80 	movl   $0x80106f76,(%esp)
80101cb5:	e8 a6 e6 ff ff       	call   80100360 <panic>
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	57                   	push   %edi
80101cc4:	89 cf                	mov    %ecx,%edi
80101cc6:	56                   	push   %esi
80101cc7:	53                   	push   %ebx
80101cc8:	89 c3                	mov    %eax,%ebx
80101cca:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ccd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cd0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101cd3:	0f 84 51 01 00 00    	je     80101e2a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cd9:	e8 02 1a 00 00       	call   801036e0 <myproc>
80101cde:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ce1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ce8:	e8 93 24 00 00       	call   80104180 <acquire>
  ip->ref++;
80101ced:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cf1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cf8:	e8 73 25 00 00       	call   80104270 <release>
80101cfd:	eb 04                	jmp    80101d03 <namex+0x43>
80101cff:	90                   	nop
    path++;
80101d00:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d03:	0f b6 03             	movzbl (%ebx),%eax
80101d06:	3c 2f                	cmp    $0x2f,%al
80101d08:	74 f6                	je     80101d00 <namex+0x40>
  if(*path == 0)
80101d0a:	84 c0                	test   %al,%al
80101d0c:	0f 84 ed 00 00 00    	je     80101dff <namex+0x13f>
  while(*path != '/' && *path != 0)
80101d12:	0f b6 03             	movzbl (%ebx),%eax
80101d15:	89 da                	mov    %ebx,%edx
80101d17:	84 c0                	test   %al,%al
80101d19:	0f 84 b1 00 00 00    	je     80101dd0 <namex+0x110>
80101d1f:	3c 2f                	cmp    $0x2f,%al
80101d21:	75 0f                	jne    80101d32 <namex+0x72>
80101d23:	e9 a8 00 00 00       	jmp    80101dd0 <namex+0x110>
80101d28:	3c 2f                	cmp    $0x2f,%al
80101d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d30:	74 0a                	je     80101d3c <namex+0x7c>
    path++;
80101d32:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d35:	0f b6 02             	movzbl (%edx),%eax
80101d38:	84 c0                	test   %al,%al
80101d3a:	75 ec                	jne    80101d28 <namex+0x68>
80101d3c:	89 d1                	mov    %edx,%ecx
80101d3e:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d40:	83 f9 0d             	cmp    $0xd,%ecx
80101d43:	0f 8e 8f 00 00 00    	jle    80101dd8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d49:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d4d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d54:	00 
80101d55:	89 3c 24             	mov    %edi,(%esp)
80101d58:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d5b:	e8 00 26 00 00       	call   80104360 <memmove>
    path++;
80101d60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d63:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d65:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d68:	75 0e                	jne    80101d78 <namex+0xb8>
80101d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d70:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d73:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d76:	74 f8                	je     80101d70 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d78:	89 34 24             	mov    %esi,(%esp)
80101d7b:	e8 70 f9 ff ff       	call   801016f0 <ilock>
    if(ip->type != T_DIR){
80101d80:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d85:	0f 85 85 00 00 00    	jne    80101e10 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d8b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d8e:	85 d2                	test   %edx,%edx
80101d90:	74 09                	je     80101d9b <namex+0xdb>
80101d92:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d95:	0f 84 a5 00 00 00    	je     80101e40 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101da2:	00 
80101da3:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101da7:	89 34 24             	mov    %esi,(%esp)
80101daa:	e8 51 fe ff ff       	call   80101c00 <dirlookup>
80101daf:	85 c0                	test   %eax,%eax
80101db1:	74 5d                	je     80101e10 <namex+0x150>
  iunlock(ip);
80101db3:	89 34 24             	mov    %esi,(%esp)
80101db6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101db9:	e8 12 fa ff ff       	call   801017d0 <iunlock>
  iput(ip);
80101dbe:	89 34 24             	mov    %esi,(%esp)
80101dc1:	e8 4a fa ff ff       	call   80101810 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dc9:	89 c6                	mov    %eax,%esi
80101dcb:	e9 33 ff ff ff       	jmp    80101d03 <namex+0x43>
  while(*path != '/' && *path != 0)
80101dd0:	31 c9                	xor    %ecx,%ecx
80101dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101dd8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101ddc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101de0:	89 3c 24             	mov    %edi,(%esp)
80101de3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101de6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101de9:	e8 72 25 00 00       	call   80104360 <memmove>
    name[len] = 0;
80101dee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101df1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101df4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101df8:	89 d3                	mov    %edx,%ebx
80101dfa:	e9 66 ff ff ff       	jmp    80101d65 <namex+0xa5>
  }
  if(nameiparent){
80101dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e02:	85 c0                	test   %eax,%eax
80101e04:	75 4c                	jne    80101e52 <namex+0x192>
80101e06:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e08:	83 c4 2c             	add    $0x2c,%esp
80101e0b:	5b                   	pop    %ebx
80101e0c:	5e                   	pop    %esi
80101e0d:	5f                   	pop    %edi
80101e0e:	5d                   	pop    %ebp
80101e0f:	c3                   	ret    
  iunlock(ip);
80101e10:	89 34 24             	mov    %esi,(%esp)
80101e13:	e8 b8 f9 ff ff       	call   801017d0 <iunlock>
  iput(ip);
80101e18:	89 34 24             	mov    %esi,(%esp)
80101e1b:	e8 f0 f9 ff ff       	call   80101810 <iput>
}
80101e20:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101e23:	31 c0                	xor    %eax,%eax
}
80101e25:	5b                   	pop    %ebx
80101e26:	5e                   	pop    %esi
80101e27:	5f                   	pop    %edi
80101e28:	5d                   	pop    %ebp
80101e29:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e2a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e2f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e34:	e8 17 f4 ff ff       	call   80101250 <iget>
80101e39:	89 c6                	mov    %eax,%esi
80101e3b:	e9 c3 fe ff ff       	jmp    80101d03 <namex+0x43>
      iunlock(ip);
80101e40:	89 34 24             	mov    %esi,(%esp)
80101e43:	e8 88 f9 ff ff       	call   801017d0 <iunlock>
}
80101e48:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101e4b:	89 f0                	mov    %esi,%eax
}
80101e4d:	5b                   	pop    %ebx
80101e4e:	5e                   	pop    %esi
80101e4f:	5f                   	pop    %edi
80101e50:	5d                   	pop    %ebp
80101e51:	c3                   	ret    
    iput(ip);
80101e52:	89 34 24             	mov    %esi,(%esp)
80101e55:	e8 b6 f9 ff ff       	call   80101810 <iput>
    return 0;
80101e5a:	31 c0                	xor    %eax,%eax
80101e5c:	eb aa                	jmp    80101e08 <namex+0x148>
80101e5e:	66 90                	xchg   %ax,%ax

80101e60 <dirlink>:
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	57                   	push   %edi
80101e64:	56                   	push   %esi
80101e65:	53                   	push   %ebx
80101e66:	83 ec 2c             	sub    $0x2c,%esp
80101e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e6f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e76:	00 
80101e77:	89 1c 24             	mov    %ebx,(%esp)
80101e7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e7e:	e8 7d fd ff ff       	call   80101c00 <dirlookup>
80101e83:	85 c0                	test   %eax,%eax
80101e85:	0f 85 8b 00 00 00    	jne    80101f16 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e8b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e8e:	31 ff                	xor    %edi,%edi
80101e90:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e93:	85 c0                	test   %eax,%eax
80101e95:	75 13                	jne    80101eaa <dirlink+0x4a>
80101e97:	eb 35                	jmp    80101ece <dirlink+0x6e>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea0:	8d 57 10             	lea    0x10(%edi),%edx
80101ea3:	39 53 58             	cmp    %edx,0x58(%ebx)
80101ea6:	89 d7                	mov    %edx,%edi
80101ea8:	76 24                	jbe    80101ece <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eaa:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101eb1:	00 
80101eb2:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101eb6:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eba:	89 1c 24             	mov    %ebx,(%esp)
80101ebd:	e8 de fa ff ff       	call   801019a0 <readi>
80101ec2:	83 f8 10             	cmp    $0x10,%eax
80101ec5:	75 5e                	jne    80101f25 <dirlink+0xc5>
    if(de.inum == 0)
80101ec7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ecc:	75 d2                	jne    80101ea0 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101ece:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ed8:	00 
80101ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101edd:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ee0:	89 04 24             	mov    %eax,(%esp)
80101ee3:	e8 68 25 00 00       	call   80104450 <strncpy>
  de.inum = inum;
80101ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eeb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ef2:	00 
80101ef3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ef7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101efb:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101efe:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f02:	e8 99 fb ff ff       	call   80101aa0 <writei>
80101f07:	83 f8 10             	cmp    $0x10,%eax
80101f0a:	75 25                	jne    80101f31 <dirlink+0xd1>
  return 0;
80101f0c:	31 c0                	xor    %eax,%eax
}
80101f0e:	83 c4 2c             	add    $0x2c,%esp
80101f11:	5b                   	pop    %ebx
80101f12:	5e                   	pop    %esi
80101f13:	5f                   	pop    %edi
80101f14:	5d                   	pop    %ebp
80101f15:	c3                   	ret    
    iput(ip);
80101f16:	89 04 24             	mov    %eax,(%esp)
80101f19:	e8 f2 f8 ff ff       	call   80101810 <iput>
    return -1;
80101f1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f23:	eb e9                	jmp    80101f0e <dirlink+0xae>
      panic("dirlink read");
80101f25:	c7 04 24 97 6f 10 80 	movl   $0x80106f97,(%esp)
80101f2c:	e8 2f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101f31:	c7 04 24 86 75 10 80 	movl   $0x80107586,(%esp)
80101f38:	e8 23 e4 ff ff       	call   80100360 <panic>
80101f3d:	8d 76 00             	lea    0x0(%esi),%esi

80101f40 <namei>:

struct inode*
namei(char *path)
{
80101f40:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f41:	31 d2                	xor    %edx,%edx
{
80101f43:	89 e5                	mov    %esp,%ebp
80101f45:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f48:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f4e:	e8 6d fd ff ff       	call   80101cc0 <namex>
}
80101f53:	c9                   	leave  
80101f54:	c3                   	ret    
80101f55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f60 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f60:	55                   	push   %ebp
  return namex(path, 1, name);
80101f61:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f66:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f6e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f6f:	e9 4c fd ff ff       	jmp    80101cc0 <namex>
80101f74:	66 90                	xchg   %ax,%ax
80101f76:	66 90                	xchg   %ax,%ax
80101f78:	66 90                	xchg   %ax,%ax
80101f7a:	66 90                	xchg   %ax,%ax
80101f7c:	66 90                	xchg   %ax,%ax
80101f7e:	66 90                	xchg   %ax,%ax

80101f80 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f80:	55                   	push   %ebp
80101f81:	89 e5                	mov    %esp,%ebp
80101f83:	56                   	push   %esi
80101f84:	89 c6                	mov    %eax,%esi
80101f86:	53                   	push   %ebx
80101f87:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f8a:	85 c0                	test   %eax,%eax
80101f8c:	0f 84 99 00 00 00    	je     8010202b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f92:	8b 48 08             	mov    0x8(%eax),%ecx
80101f95:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f9b:	0f 87 7e 00 00 00    	ja     8010201f <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fa1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fa6:	66 90                	xchg   %ax,%ax
80101fa8:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fa9:	83 e0 c0             	and    $0xffffffc0,%eax
80101fac:	3c 40                	cmp    $0x40,%al
80101fae:	75 f8                	jne    80101fa8 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fb0:	31 db                	xor    %ebx,%ebx
80101fb2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fb7:	89 d8                	mov    %ebx,%eax
80101fb9:	ee                   	out    %al,(%dx)
80101fba:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fbf:	b8 01 00 00 00       	mov    $0x1,%eax
80101fc4:	ee                   	out    %al,(%dx)
80101fc5:	0f b6 c1             	movzbl %cl,%eax
80101fc8:	b2 f3                	mov    $0xf3,%dl
80101fca:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fcb:	89 c8                	mov    %ecx,%eax
80101fcd:	b2 f4                	mov    $0xf4,%dl
80101fcf:	c1 f8 08             	sar    $0x8,%eax
80101fd2:	ee                   	out    %al,(%dx)
80101fd3:	b2 f5                	mov    $0xf5,%dl
80101fd5:	89 d8                	mov    %ebx,%eax
80101fd7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fd8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fdc:	b2 f6                	mov    $0xf6,%dl
80101fde:	83 e0 01             	and    $0x1,%eax
80101fe1:	c1 e0 04             	shl    $0x4,%eax
80101fe4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fe7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fe8:	f6 06 04             	testb  $0x4,(%esi)
80101feb:	75 13                	jne    80102000 <idestart+0x80>
80101fed:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ff2:	b8 20 00 00 00       	mov    $0x20,%eax
80101ff7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101ff8:	83 c4 10             	add    $0x10,%esp
80101ffb:	5b                   	pop    %ebx
80101ffc:	5e                   	pop    %esi
80101ffd:	5d                   	pop    %ebp
80101ffe:	c3                   	ret    
80101fff:	90                   	nop
80102000:	b2 f7                	mov    $0xf7,%dl
80102002:	b8 30 00 00 00       	mov    $0x30,%eax
80102007:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102008:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010200d:	83 c6 5c             	add    $0x5c,%esi
80102010:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102015:	fc                   	cld    
80102016:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102018:	83 c4 10             	add    $0x10,%esp
8010201b:	5b                   	pop    %ebx
8010201c:	5e                   	pop    %esi
8010201d:	5d                   	pop    %ebp
8010201e:	c3                   	ret    
    panic("incorrect blockno");
8010201f:	c7 04 24 00 70 10 80 	movl   $0x80107000,(%esp)
80102026:	e8 35 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
8010202b:	c7 04 24 f7 6f 10 80 	movl   $0x80106ff7,(%esp)
80102032:	e8 29 e3 ff ff       	call   80100360 <panic>
80102037:	89 f6                	mov    %esi,%esi
80102039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102040 <ideinit>:
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102046:	c7 44 24 04 12 70 10 	movl   $0x80107012,0x4(%esp)
8010204d:	80 
8010204e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102055:	e8 36 20 00 00       	call   80104090 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010205a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010205f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102066:	83 e8 01             	sub    $0x1,%eax
80102069:	89 44 24 04          	mov    %eax,0x4(%esp)
8010206d:	e8 7e 02 00 00       	call   801022f0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102072:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102077:	90                   	nop
80102078:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102079:	83 e0 c0             	and    $0xffffffc0,%eax
8010207c:	3c 40                	cmp    $0x40,%al
8010207e:	75 f8                	jne    80102078 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102080:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102085:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010208a:	ee                   	out    %al,(%dx)
8010208b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102090:	b2 f7                	mov    $0xf7,%dl
80102092:	eb 09                	jmp    8010209d <ideinit+0x5d>
80102094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102098:	83 e9 01             	sub    $0x1,%ecx
8010209b:	74 0f                	je     801020ac <ideinit+0x6c>
8010209d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010209e:	84 c0                	test   %al,%al
801020a0:	74 f6                	je     80102098 <ideinit+0x58>
      havedisk1 = 1;
801020a2:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801020a9:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ac:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020b1:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020b6:	ee                   	out    %al,(%dx)
}
801020b7:	c9                   	leave  
801020b8:	c3                   	ret    
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020c9:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020d0:	e8 ab 20 00 00       	call   80104180 <acquire>

  if((b = idequeue) == 0){
801020d5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020db:	85 db                	test   %ebx,%ebx
801020dd:	74 30                	je     8010210f <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020df:	8b 43 58             	mov    0x58(%ebx),%eax
801020e2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020e7:	8b 33                	mov    (%ebx),%esi
801020e9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020ef:	74 37                	je     80102128 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020f1:	83 e6 fb             	and    $0xfffffffb,%esi
801020f4:	83 ce 02             	or     $0x2,%esi
801020f7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020f9:	89 1c 24             	mov    %ebx,(%esp)
801020fc:	e8 cf 1c 00 00       	call   80103dd0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102101:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102106:	85 c0                	test   %eax,%eax
80102108:	74 05                	je     8010210f <ideintr+0x4f>
    idestart(idequeue);
8010210a:	e8 71 fe ff ff       	call   80101f80 <idestart>
    release(&idelock);
8010210f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102116:	e8 55 21 00 00       	call   80104270 <release>

  release(&idelock);
}
8010211b:	83 c4 1c             	add    $0x1c,%esp
8010211e:	5b                   	pop    %ebx
8010211f:	5e                   	pop    %esi
80102120:	5f                   	pop    %edi
80102121:	5d                   	pop    %ebp
80102122:	c3                   	ret    
80102123:	90                   	nop
80102124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102128:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010212d:	8d 76 00             	lea    0x0(%esi),%esi
80102130:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102131:	89 c1                	mov    %eax,%ecx
80102133:	83 e1 c0             	and    $0xffffffc0,%ecx
80102136:	80 f9 40             	cmp    $0x40,%cl
80102139:	75 f5                	jne    80102130 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010213b:	a8 21                	test   $0x21,%al
8010213d:	75 b2                	jne    801020f1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
8010213f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102142:	b9 80 00 00 00       	mov    $0x80,%ecx
80102147:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010214c:	fc                   	cld    
8010214d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010214f:	8b 33                	mov    (%ebx),%esi
80102151:	eb 9e                	jmp    801020f1 <ideintr+0x31>
80102153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102160 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	53                   	push   %ebx
80102164:	83 ec 14             	sub    $0x14,%esp
80102167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010216a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010216d:	89 04 24             	mov    %eax,(%esp)
80102170:	e8 eb 1e 00 00       	call   80104060 <holdingsleep>
80102175:	85 c0                	test   %eax,%eax
80102177:	0f 84 9e 00 00 00    	je     8010221b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010217d:	8b 03                	mov    (%ebx),%eax
8010217f:	83 e0 06             	and    $0x6,%eax
80102182:	83 f8 02             	cmp    $0x2,%eax
80102185:	0f 84 a8 00 00 00    	je     80102233 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010218b:	8b 53 04             	mov    0x4(%ebx),%edx
8010218e:	85 d2                	test   %edx,%edx
80102190:	74 0d                	je     8010219f <iderw+0x3f>
80102192:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102197:	85 c0                	test   %eax,%eax
80102199:	0f 84 88 00 00 00    	je     80102227 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010219f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801021a6:	e8 d5 1f 00 00       	call   80104180 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ab:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801021b0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021b7:	85 c0                	test   %eax,%eax
801021b9:	75 07                	jne    801021c2 <iderw+0x62>
801021bb:	eb 4e                	jmp    8010220b <iderw+0xab>
801021bd:	8d 76 00             	lea    0x0(%esi),%esi
801021c0:	89 d0                	mov    %edx,%eax
801021c2:	8b 50 58             	mov    0x58(%eax),%edx
801021c5:	85 d2                	test   %edx,%edx
801021c7:	75 f7                	jne    801021c0 <iderw+0x60>
801021c9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021cc:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021ce:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021d4:	74 3c                	je     80102212 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021d6:	8b 03                	mov    (%ebx),%eax
801021d8:	83 e0 06             	and    $0x6,%eax
801021db:	83 f8 02             	cmp    $0x2,%eax
801021de:	74 1a                	je     801021fa <iderw+0x9a>
    sleep(b, &idelock);
801021e0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021e7:	80 
801021e8:	89 1c 24             	mov    %ebx,(%esp)
801021eb:	e8 50 1a 00 00       	call   80103c40 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021f0:	8b 13                	mov    (%ebx),%edx
801021f2:	83 e2 06             	and    $0x6,%edx
801021f5:	83 fa 02             	cmp    $0x2,%edx
801021f8:	75 e6                	jne    801021e0 <iderw+0x80>
  }


  release(&idelock);
801021fa:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102201:	83 c4 14             	add    $0x14,%esp
80102204:	5b                   	pop    %ebx
80102205:	5d                   	pop    %ebp
  release(&idelock);
80102206:	e9 65 20 00 00       	jmp    80104270 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010220b:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
80102210:	eb ba                	jmp    801021cc <iderw+0x6c>
    idestart(b);
80102212:	89 d8                	mov    %ebx,%eax
80102214:	e8 67 fd ff ff       	call   80101f80 <idestart>
80102219:	eb bb                	jmp    801021d6 <iderw+0x76>
    panic("iderw: buf not locked");
8010221b:	c7 04 24 16 70 10 80 	movl   $0x80107016,(%esp)
80102222:	e8 39 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
80102227:	c7 04 24 41 70 10 80 	movl   $0x80107041,(%esp)
8010222e:	e8 2d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102233:	c7 04 24 2c 70 10 80 	movl   $0x8010702c,(%esp)
8010223a:	e8 21 e1 ff ff       	call   80100360 <panic>
8010223f:	90                   	nop

80102240 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	56                   	push   %esi
80102244:	53                   	push   %ebx
80102245:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102248:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010224f:	00 c0 fe 
  ioapic->reg = reg;
80102252:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102259:	00 00 00 
  return ioapic->data;
8010225c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102262:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102265:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010226b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102271:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102278:	c1 e8 10             	shr    $0x10,%eax
8010227b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010227e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102281:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102284:	39 c2                	cmp    %eax,%edx
80102286:	74 12                	je     8010229a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102288:	c7 04 24 60 70 10 80 	movl   $0x80107060,(%esp)
8010228f:	e8 bc e3 ff ff       	call   80100650 <cprintf>
80102294:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010229a:	ba 10 00 00 00       	mov    $0x10,%edx
8010229f:	31 c0                	xor    %eax,%eax
801022a1:	eb 07                	jmp    801022aa <ioapicinit+0x6a>
801022a3:	90                   	nop
801022a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022a8:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
801022aa:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
801022ac:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801022b2:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022b5:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
801022bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022be:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022c1:	8d 4a 01             	lea    0x1(%edx),%ecx
801022c4:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801022c7:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022c9:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
801022cf:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
801022d1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022d8:	7d ce                	jge    801022a8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022da:	83 c4 10             	add    $0x10,%esp
801022dd:	5b                   	pop    %ebx
801022de:	5e                   	pop    %esi
801022df:	5d                   	pop    %ebp
801022e0:	c3                   	ret    
801022e1:	eb 0d                	jmp    801022f0 <ioapicenable>
801022e3:	90                   	nop
801022e4:	90                   	nop
801022e5:	90                   	nop
801022e6:	90                   	nop
801022e7:	90                   	nop
801022e8:	90                   	nop
801022e9:	90                   	nop
801022ea:	90                   	nop
801022eb:	90                   	nop
801022ec:	90                   	nop
801022ed:	90                   	nop
801022ee:	90                   	nop
801022ef:	90                   	nop

801022f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	8b 55 08             	mov    0x8(%ebp),%edx
801022f6:	53                   	push   %ebx
801022f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022fa:	8d 5a 20             	lea    0x20(%edx),%ebx
801022fd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
80102301:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102307:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
8010230a:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010230c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102312:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
80102315:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
80102318:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010231a:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102320:	89 42 10             	mov    %eax,0x10(%edx)
}
80102323:	5b                   	pop    %ebx
80102324:	5d                   	pop    %ebp
80102325:	c3                   	ret    
80102326:	66 90                	xchg   %ax,%ax
80102328:	66 90                	xchg   %ax,%ax
8010232a:	66 90                	xchg   %ax,%ax
8010232c:	66 90                	xchg   %ax,%ax
8010232e:	66 90                	xchg   %ax,%ax

80102330 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	53                   	push   %ebx
80102334:	83 ec 14             	sub    $0x14,%esp
80102337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010233a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102340:	75 7c                	jne    801023be <kfree+0x8e>
80102342:	81 fb f4 58 11 80    	cmp    $0x801158f4,%ebx
80102348:	72 74                	jb     801023be <kfree+0x8e>
8010234a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102350:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102355:	77 67                	ja     801023be <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102357:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010235e:	00 
8010235f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102366:	00 
80102367:	89 1c 24             	mov    %ebx,(%esp)
8010236a:	e8 51 1f 00 00       	call   801042c0 <memset>

  if(kmem.use_lock)
8010236f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102375:	85 d2                	test   %edx,%edx
80102377:	75 37                	jne    801023b0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102379:	a1 78 26 11 80       	mov    0x80112678,%eax
8010237e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102380:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102385:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010238b:	85 c0                	test   %eax,%eax
8010238d:	75 09                	jne    80102398 <kfree+0x68>
    release(&kmem.lock);
}
8010238f:	83 c4 14             	add    $0x14,%esp
80102392:	5b                   	pop    %ebx
80102393:	5d                   	pop    %ebp
80102394:	c3                   	ret    
80102395:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102398:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010239f:	83 c4 14             	add    $0x14,%esp
801023a2:	5b                   	pop    %ebx
801023a3:	5d                   	pop    %ebp
    release(&kmem.lock);
801023a4:	e9 c7 1e 00 00       	jmp    80104270 <release>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801023b0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023b7:	e8 c4 1d 00 00       	call   80104180 <acquire>
801023bc:	eb bb                	jmp    80102379 <kfree+0x49>
    panic("kfree");
801023be:	c7 04 24 92 70 10 80 	movl   $0x80107092,(%esp)
801023c5:	e8 96 df ff ff       	call   80100360 <panic>
801023ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023d0 <freerange>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801023d8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023db:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023de:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023e4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ea:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023f0:	39 de                	cmp    %ebx,%esi
801023f2:	73 08                	jae    801023fc <freerange+0x2c>
801023f4:	eb 18                	jmp    8010240e <freerange+0x3e>
801023f6:	66 90                	xchg   %ax,%ax
801023f8:	89 da                	mov    %ebx,%edx
801023fa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023fc:	89 14 24             	mov    %edx,(%esp)
801023ff:	e8 2c ff ff ff       	call   80102330 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102404:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010240a:	39 f0                	cmp    %esi,%eax
8010240c:	76 ea                	jbe    801023f8 <freerange+0x28>
}
8010240e:	83 c4 10             	add    $0x10,%esp
80102411:	5b                   	pop    %ebx
80102412:	5e                   	pop    %esi
80102413:	5d                   	pop    %ebp
80102414:	c3                   	ret    
80102415:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102420 <kinit1>:
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx
80102425:	83 ec 10             	sub    $0x10,%esp
80102428:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010242b:	c7 44 24 04 98 70 10 	movl   $0x80107098,0x4(%esp)
80102432:	80 
80102433:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010243a:	e8 51 1c 00 00       	call   80104090 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010243f:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102442:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102449:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010244c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102452:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102458:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010245e:	39 de                	cmp    %ebx,%esi
80102460:	73 0a                	jae    8010246c <kinit1+0x4c>
80102462:	eb 1a                	jmp    8010247e <kinit1+0x5e>
80102464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102468:	89 da                	mov    %ebx,%edx
8010246a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010246c:	89 14 24             	mov    %edx,(%esp)
8010246f:	e8 bc fe ff ff       	call   80102330 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102474:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010247a:	39 c6                	cmp    %eax,%esi
8010247c:	73 ea                	jae    80102468 <kinit1+0x48>
}
8010247e:	83 c4 10             	add    $0x10,%esp
80102481:	5b                   	pop    %ebx
80102482:	5e                   	pop    %esi
80102483:	5d                   	pop    %ebp
80102484:	c3                   	ret    
80102485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kinit2>:
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
80102494:	53                   	push   %ebx
80102495:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102498:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010249b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010249e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801024a4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024aa:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024b0:	39 de                	cmp    %ebx,%esi
801024b2:	73 08                	jae    801024bc <kinit2+0x2c>
801024b4:	eb 18                	jmp    801024ce <kinit2+0x3e>
801024b6:	66 90                	xchg   %ax,%ax
801024b8:	89 da                	mov    %ebx,%edx
801024ba:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024bc:	89 14 24             	mov    %edx,(%esp)
801024bf:	e8 6c fe ff ff       	call   80102330 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024ca:	39 c6                	cmp    %eax,%esi
801024cc:	73 ea                	jae    801024b8 <kinit2+0x28>
  kmem.use_lock = 1;
801024ce:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024d5:	00 00 00 
}
801024d8:	83 c4 10             	add    $0x10,%esp
801024db:	5b                   	pop    %ebx
801024dc:	5e                   	pop    %esi
801024dd:	5d                   	pop    %ebp
801024de:	c3                   	ret    
801024df:	90                   	nop

801024e0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024e7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024ec:	85 c0                	test   %eax,%eax
801024ee:	75 30                	jne    80102520 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024f0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024f6:	85 db                	test   %ebx,%ebx
801024f8:	74 08                	je     80102502 <kalloc+0x22>
    kmem.freelist = r->next;
801024fa:	8b 13                	mov    (%ebx),%edx
801024fc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102502:	85 c0                	test   %eax,%eax
80102504:	74 0c                	je     80102512 <kalloc+0x32>
    release(&kmem.lock);
80102506:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010250d:	e8 5e 1d 00 00       	call   80104270 <release>
  return (char*)r;
}
80102512:	83 c4 14             	add    $0x14,%esp
80102515:	89 d8                	mov    %ebx,%eax
80102517:	5b                   	pop    %ebx
80102518:	5d                   	pop    %ebp
80102519:	c3                   	ret    
8010251a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102520:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102527:	e8 54 1c 00 00       	call   80104180 <acquire>
8010252c:	a1 74 26 11 80       	mov    0x80112674,%eax
80102531:	eb bd                	jmp    801024f0 <kalloc+0x10>
80102533:	66 90                	xchg   %ax,%ax
80102535:	66 90                	xchg   %ax,%ax
80102537:	66 90                	xchg   %ax,%ax
80102539:	66 90                	xchg   %ax,%ax
8010253b:	66 90                	xchg   %ax,%ax
8010253d:	66 90                	xchg   %ax,%ax
8010253f:	90                   	nop

80102540 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102540:	ba 64 00 00 00       	mov    $0x64,%edx
80102545:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102546:	a8 01                	test   $0x1,%al
80102548:	0f 84 ba 00 00 00    	je     80102608 <kbdgetc+0xc8>
8010254e:	b2 60                	mov    $0x60,%dl
80102550:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102551:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102554:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010255a:	0f 84 88 00 00 00    	je     801025e8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102560:	84 c0                	test   %al,%al
80102562:	79 2c                	jns    80102590 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102564:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010256a:	f6 c2 40             	test   $0x40,%dl
8010256d:	75 05                	jne    80102574 <kbdgetc+0x34>
8010256f:	89 c1                	mov    %eax,%ecx
80102571:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102574:	0f b6 81 c0 71 10 80 	movzbl -0x7fef8e40(%ecx),%eax
8010257b:	83 c8 40             	or     $0x40,%eax
8010257e:	0f b6 c0             	movzbl %al,%eax
80102581:	f7 d0                	not    %eax
80102583:	21 d0                	and    %edx,%eax
80102585:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010258a:	31 c0                	xor    %eax,%eax
8010258c:	c3                   	ret    
8010258d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	53                   	push   %ebx
80102594:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010259a:	f6 c3 40             	test   $0x40,%bl
8010259d:	74 09                	je     801025a8 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010259f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025a2:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801025a5:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801025a8:	0f b6 91 c0 71 10 80 	movzbl -0x7fef8e40(%ecx),%edx
  shift ^= togglecode[data];
801025af:	0f b6 81 c0 70 10 80 	movzbl -0x7fef8f40(%ecx),%eax
  shift |= shiftcode[data];
801025b6:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801025b8:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025ba:	89 d0                	mov    %edx,%eax
801025bc:	83 e0 03             	and    $0x3,%eax
801025bf:	8b 04 85 a0 70 10 80 	mov    -0x7fef8f60(,%eax,4),%eax
  shift ^= togglecode[data];
801025c6:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
801025cc:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025cf:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025d3:	74 0b                	je     801025e0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025d5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025d8:	83 fa 19             	cmp    $0x19,%edx
801025db:	77 1b                	ja     801025f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025dd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025e0:	5b                   	pop    %ebx
801025e1:	5d                   	pop    %ebp
801025e2:	c3                   	ret    
801025e3:	90                   	nop
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025e8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025ef:	31 c0                	xor    %eax,%eax
801025f1:	c3                   	ret    
801025f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801025f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025fb:	8d 50 20             	lea    0x20(%eax),%edx
801025fe:	83 f9 19             	cmp    $0x19,%ecx
80102601:	0f 46 c2             	cmovbe %edx,%eax
  return c;
80102604:	eb da                	jmp    801025e0 <kbdgetc+0xa0>
80102606:	66 90                	xchg   %ax,%ax
    return -1;
80102608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010260d:	c3                   	ret    
8010260e:	66 90                	xchg   %ax,%ax

80102610 <kbdintr>:

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102616:	c7 04 24 40 25 10 80 	movl   $0x80102540,(%esp)
8010261d:	e8 8e e1 ff ff       	call   801007b0 <consoleintr>
}
80102622:	c9                   	leave  
80102623:	c3                   	ret    
80102624:	66 90                	xchg   %ax,%ax
80102626:	66 90                	xchg   %ax,%ax
80102628:	66 90                	xchg   %ax,%ax
8010262a:	66 90                	xchg   %ax,%ax
8010262c:	66 90                	xchg   %ax,%ax
8010262e:	66 90                	xchg   %ax,%ax

80102630 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102630:	55                   	push   %ebp
80102631:	89 c1                	mov    %eax,%ecx
80102633:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102635:	ba 70 00 00 00       	mov    $0x70,%edx
8010263a:	53                   	push   %ebx
8010263b:	31 c0                	xor    %eax,%eax
8010263d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010263e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102643:	89 da                	mov    %ebx,%edx
80102645:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102646:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102649:	b2 70                	mov    $0x70,%dl
8010264b:	89 01                	mov    %eax,(%ecx)
8010264d:	b8 02 00 00 00       	mov    $0x2,%eax
80102652:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102653:	89 da                	mov    %ebx,%edx
80102655:	ec                   	in     (%dx),%al
80102656:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102659:	b2 70                	mov    $0x70,%dl
8010265b:	89 41 04             	mov    %eax,0x4(%ecx)
8010265e:	b8 04 00 00 00       	mov    $0x4,%eax
80102663:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102664:	89 da                	mov    %ebx,%edx
80102666:	ec                   	in     (%dx),%al
80102667:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010266a:	b2 70                	mov    $0x70,%dl
8010266c:	89 41 08             	mov    %eax,0x8(%ecx)
8010266f:	b8 07 00 00 00       	mov    $0x7,%eax
80102674:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102675:	89 da                	mov    %ebx,%edx
80102677:	ec                   	in     (%dx),%al
80102678:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010267b:	b2 70                	mov    $0x70,%dl
8010267d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102680:	b8 08 00 00 00       	mov    $0x8,%eax
80102685:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102686:	89 da                	mov    %ebx,%edx
80102688:	ec                   	in     (%dx),%al
80102689:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010268c:	b2 70                	mov    $0x70,%dl
8010268e:	89 41 10             	mov    %eax,0x10(%ecx)
80102691:	b8 09 00 00 00       	mov    $0x9,%eax
80102696:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102697:	89 da                	mov    %ebx,%edx
80102699:	ec                   	in     (%dx),%al
8010269a:	0f b6 d8             	movzbl %al,%ebx
8010269d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
801026a0:	5b                   	pop    %ebx
801026a1:	5d                   	pop    %ebp
801026a2:	c3                   	ret    
801026a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026b0 <lapicinit>:
  if(!lapic)
801026b0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801026b5:	55                   	push   %ebp
801026b6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026b8:	85 c0                	test   %eax,%eax
801026ba:	0f 84 c0 00 00 00    	je     80102780 <lapicinit+0xd0>
  lapic[index] = value;
801026c0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026c7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026cd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026da:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026e1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ee:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026f1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026fb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102701:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102708:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010270b:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010270e:	8b 50 30             	mov    0x30(%eax),%edx
80102711:	c1 ea 10             	shr    $0x10,%edx
80102714:	80 fa 03             	cmp    $0x3,%dl
80102717:	77 6f                	ja     80102788 <lapicinit+0xd8>
  lapic[index] = value;
80102719:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102720:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102723:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102726:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010272d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102730:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102733:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010273a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102740:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102747:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010274d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102754:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102757:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010275a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102761:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102764:	8b 50 20             	mov    0x20(%eax),%edx
80102767:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102768:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010276e:	80 e6 10             	and    $0x10,%dh
80102771:	75 f5                	jne    80102768 <lapicinit+0xb8>
  lapic[index] = value;
80102773:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010277a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010277d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102780:	5d                   	pop    %ebp
80102781:	c3                   	ret    
80102782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102788:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010278f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102792:	8b 50 20             	mov    0x20(%eax),%edx
80102795:	eb 82                	jmp    80102719 <lapicinit+0x69>
80102797:	89 f6                	mov    %esi,%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicid>:
  if (!lapic)
801027a0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027a5:	55                   	push   %ebp
801027a6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027a8:	85 c0                	test   %eax,%eax
801027aa:	74 0c                	je     801027b8 <lapicid+0x18>
  return lapic[ID] >> 24;
801027ac:	8b 40 20             	mov    0x20(%eax),%eax
}
801027af:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
801027b0:	c1 e8 18             	shr    $0x18,%eax
}
801027b3:	c3                   	ret    
801027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801027b8:	31 c0                	xor    %eax,%eax
}
801027ba:	5d                   	pop    %ebp
801027bb:	c3                   	ret    
801027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027c0 <lapiceoi>:
  if(lapic)
801027c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027c5:	55                   	push   %ebp
801027c6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027c8:	85 c0                	test   %eax,%eax
801027ca:	74 0d                	je     801027d9 <lapiceoi+0x19>
  lapic[index] = value;
801027cc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027d3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 40 20             	mov    0x20(%eax),%eax
}
801027d9:	5d                   	pop    %ebp
801027da:	c3                   	ret    
801027db:	90                   	nop
801027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027e0 <microdelay>:
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
}
801027e3:	5d                   	pop    %ebp
801027e4:	c3                   	ret    
801027e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027f0 <lapicstartap>:
{
801027f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f1:	ba 70 00 00 00       	mov    $0x70,%edx
801027f6:	89 e5                	mov    %esp,%ebp
801027f8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027fd:	53                   	push   %ebx
801027fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102801:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102804:	ee                   	out    %al,(%dx)
80102805:	b8 0a 00 00 00       	mov    $0xa,%eax
8010280a:	b2 71                	mov    $0x71,%dl
8010280c:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
8010280d:	31 c0                	xor    %eax,%eax
8010280f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102815:	89 d8                	mov    %ebx,%eax
80102817:	c1 e8 04             	shr    $0x4,%eax
8010281a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102820:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
80102825:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102828:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
8010282b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010283b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102848:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102854:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102857:	89 da                	mov    %ebx,%edx
80102859:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010285c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102862:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102865:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010286b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010286e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102874:	8b 40 20             	mov    0x20(%eax),%eax
}
80102877:	5b                   	pop    %ebx
80102878:	5d                   	pop    %ebp
80102879:	c3                   	ret    
8010287a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102880 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102880:	55                   	push   %ebp
80102881:	ba 70 00 00 00       	mov    $0x70,%edx
80102886:	89 e5                	mov    %esp,%ebp
80102888:	b8 0b 00 00 00       	mov    $0xb,%eax
8010288d:	57                   	push   %edi
8010288e:	56                   	push   %esi
8010288f:	53                   	push   %ebx
80102890:	83 ec 4c             	sub    $0x4c,%esp
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	b2 71                	mov    $0x71,%dl
80102896:	ec                   	in     (%dx),%al
80102897:	88 45 b7             	mov    %al,-0x49(%ebp)
8010289a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010289d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
801028a1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801028a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a8:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801028ad:	89 d8                	mov    %ebx,%eax
801028af:	e8 7c fd ff ff       	call   80102630 <fill_rtcdate>
801028b4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028b9:	89 f2                	mov    %esi,%edx
801028bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bc:	ba 71 00 00 00       	mov    $0x71,%edx
801028c1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028c2:	84 c0                	test   %al,%al
801028c4:	78 e7                	js     801028ad <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028c6:	89 f8                	mov    %edi,%eax
801028c8:	e8 63 fd ff ff       	call   80102630 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028cd:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028d4:	00 
801028d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028d9:	89 1c 24             	mov    %ebx,(%esp)
801028dc:	e8 2f 1a 00 00       	call   80104310 <memcmp>
801028e1:	85 c0                	test   %eax,%eax
801028e3:	75 c3                	jne    801028a8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028e5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028e9:	75 78                	jne    80102963 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ee:	89 c2                	mov    %eax,%edx
801028f0:	83 e0 0f             	and    $0xf,%eax
801028f3:	c1 ea 04             	shr    $0x4,%edx
801028f6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028fc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028ff:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102902:	89 c2                	mov    %eax,%edx
80102904:	83 e0 0f             	and    $0xf,%eax
80102907:	c1 ea 04             	shr    $0x4,%edx
8010290a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010290d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102910:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102913:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102916:	89 c2                	mov    %eax,%edx
80102918:	83 e0 0f             	and    $0xf,%eax
8010291b:	c1 ea 04             	shr    $0x4,%edx
8010291e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102921:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102924:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102927:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010292a:	89 c2                	mov    %eax,%edx
8010292c:	83 e0 0f             	and    $0xf,%eax
8010292f:	c1 ea 04             	shr    $0x4,%edx
80102932:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102935:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102938:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010293b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010293e:	89 c2                	mov    %eax,%edx
80102940:	83 e0 0f             	and    $0xf,%eax
80102943:	c1 ea 04             	shr    $0x4,%edx
80102946:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102949:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010294c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010294f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102952:	89 c2                	mov    %eax,%edx
80102954:	83 e0 0f             	and    $0xf,%eax
80102957:	c1 ea 04             	shr    $0x4,%edx
8010295a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102960:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102963:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102966:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102969:	89 01                	mov    %eax,(%ecx)
8010296b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010296e:	89 41 04             	mov    %eax,0x4(%ecx)
80102971:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102974:	89 41 08             	mov    %eax,0x8(%ecx)
80102977:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010297a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010297d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102980:	89 41 10             	mov    %eax,0x10(%ecx)
80102983:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102986:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102989:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102990:	83 c4 4c             	add    $0x4c,%esp
80102993:	5b                   	pop    %ebx
80102994:	5e                   	pop    %esi
80102995:	5f                   	pop    %edi
80102996:	5d                   	pop    %ebp
80102997:	c3                   	ret    
80102998:	66 90                	xchg   %ax,%ax
8010299a:	66 90                	xchg   %ax,%ax
8010299c:	66 90                	xchg   %ax,%ax
8010299e:	66 90                	xchg   %ax,%ax

801029a0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029a0:	55                   	push   %ebp
801029a1:	89 e5                	mov    %esp,%ebp
801029a3:	57                   	push   %edi
801029a4:	56                   	push   %esi
801029a5:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029a6:	31 db                	xor    %ebx,%ebx
{
801029a8:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801029ab:	a1 c8 26 11 80       	mov    0x801126c8,%eax
801029b0:	85 c0                	test   %eax,%eax
801029b2:	7e 78                	jle    80102a2c <install_trans+0x8c>
801029b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029b8:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029bd:	01 d8                	add    %ebx,%eax
801029bf:	83 c0 01             	add    $0x1,%eax
801029c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c6:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029cb:	89 04 24             	mov    %eax,(%esp)
801029ce:	e8 fd d6 ff ff       	call   801000d0 <bread>
801029d3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029d5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
801029dc:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029df:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029e8:	89 04 24             	mov    %eax,(%esp)
801029eb:	e8 e0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029f0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029f7:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029f8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029fa:	8d 47 5c             	lea    0x5c(%edi),%eax
801029fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a01:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a04:	89 04 24             	mov    %eax,(%esp)
80102a07:	e8 54 19 00 00       	call   80104360 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a0c:	89 34 24             	mov    %esi,(%esp)
80102a0f:	e8 8c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a14:	89 3c 24             	mov    %edi,(%esp)
80102a17:	e8 c4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a1c:	89 34 24             	mov    %esi,(%esp)
80102a1f:	e8 bc d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a24:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a2a:	7f 8c                	jg     801029b8 <install_trans+0x18>
  }
}
80102a2c:	83 c4 1c             	add    $0x1c,%esp
80102a2f:	5b                   	pop    %ebx
80102a30:	5e                   	pop    %esi
80102a31:	5f                   	pop    %edi
80102a32:	5d                   	pop    %ebp
80102a33:	c3                   	ret    
80102a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
80102a43:	57                   	push   %edi
80102a44:	56                   	push   %esi
80102a45:	53                   	push   %ebx
80102a46:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a49:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a52:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a57:	89 04 24             	mov    %eax,(%esp)
80102a5a:	e8 71 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a5f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a65:	31 d2                	xor    %edx,%edx
80102a67:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a69:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a6b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a6e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a71:	7e 17                	jle    80102a8a <write_head+0x4a>
80102a73:	90                   	nop
80102a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a78:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a7f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a83:	83 c2 01             	add    $0x1,%edx
80102a86:	39 da                	cmp    %ebx,%edx
80102a88:	75 ee                	jne    80102a78 <write_head+0x38>
  }
  bwrite(buf);
80102a8a:	89 3c 24             	mov    %edi,(%esp)
80102a8d:	e8 0e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a92:	89 3c 24             	mov    %edi,(%esp)
80102a95:	e8 46 d7 ff ff       	call   801001e0 <brelse>
}
80102a9a:	83 c4 1c             	add    $0x1c,%esp
80102a9d:	5b                   	pop    %ebx
80102a9e:	5e                   	pop    %esi
80102a9f:	5f                   	pop    %edi
80102aa0:	5d                   	pop    %ebp
80102aa1:	c3                   	ret    
80102aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ab0 <initlog>:
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	56                   	push   %esi
80102ab4:	53                   	push   %ebx
80102ab5:	83 ec 30             	sub    $0x30,%esp
80102ab8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102abb:	c7 44 24 04 c0 72 10 	movl   $0x801072c0,0x4(%esp)
80102ac2:	80 
80102ac3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102aca:	e8 c1 15 00 00       	call   80104090 <initlock>
  readsb(dev, &sb);
80102acf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ad6:	89 1c 24             	mov    %ebx,(%esp)
80102ad9:	e8 f2 e8 ff ff       	call   801013d0 <readsb>
  log.start = sb.logstart;
80102ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ae1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102ae4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102ae7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102aed:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102af1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102af7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102afc:	e8 cf d5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102b01:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102b03:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b06:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b09:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b0b:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b11:	7e 17                	jle    80102b2a <initlog+0x7a>
80102b13:	90                   	nop
80102b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b18:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b1c:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102b23:	83 c2 01             	add    $0x1,%edx
80102b26:	39 da                	cmp    %ebx,%edx
80102b28:	75 ee                	jne    80102b18 <initlog+0x68>
  brelse(buf);
80102b2a:	89 04 24             	mov    %eax,(%esp)
80102b2d:	e8 ae d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b32:	e8 69 fe ff ff       	call   801029a0 <install_trans>
  log.lh.n = 0;
80102b37:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b3e:	00 00 00 
  write_head(); // clear the log
80102b41:	e8 fa fe ff ff       	call   80102a40 <write_head>
}
80102b46:	83 c4 30             	add    $0x30,%esp
80102b49:	5b                   	pop    %ebx
80102b4a:	5e                   	pop    %esi
80102b4b:	5d                   	pop    %ebp
80102b4c:	c3                   	ret    
80102b4d:	8d 76 00             	lea    0x0(%esi),%esi

80102b50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b56:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b5d:	e8 1e 16 00 00       	call   80104180 <acquire>
80102b62:	eb 18                	jmp    80102b7c <begin_op+0x2c>
80102b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b68:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b6f:	80 
80102b70:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b77:	e8 c4 10 00 00       	call   80103c40 <sleep>
    if(log.committing){
80102b7c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b81:	85 c0                	test   %eax,%eax
80102b83:	75 e3                	jne    80102b68 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b85:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b8a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b90:	83 c0 01             	add    $0x1,%eax
80102b93:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b96:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b99:	83 fa 1e             	cmp    $0x1e,%edx
80102b9c:	7f ca                	jg     80102b68 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b9e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102ba5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102baa:	e8 c1 16 00 00       	call   80104270 <release>
      break;
    }
  }
}
80102baf:	c9                   	leave  
80102bb0:	c3                   	ret    
80102bb1:	eb 0d                	jmp    80102bc0 <end_op>
80102bb3:	90                   	nop
80102bb4:	90                   	nop
80102bb5:	90                   	nop
80102bb6:	90                   	nop
80102bb7:	90                   	nop
80102bb8:	90                   	nop
80102bb9:	90                   	nop
80102bba:	90                   	nop
80102bbb:	90                   	nop
80102bbc:	90                   	nop
80102bbd:	90                   	nop
80102bbe:	90                   	nop
80102bbf:	90                   	nop

80102bc0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	57                   	push   %edi
80102bc4:	56                   	push   %esi
80102bc5:	53                   	push   %ebx
80102bc6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bc9:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bd0:	e8 ab 15 00 00       	call   80104180 <acquire>
  log.outstanding -= 1;
80102bd5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bda:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102be0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102be3:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102be5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bea:	0f 85 f3 00 00 00    	jne    80102ce3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bf0:	85 c0                	test   %eax,%eax
80102bf2:	0f 85 cb 00 00 00    	jne    80102cc3 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bf8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bff:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102c01:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c08:	00 00 00 
  release(&log.lock);
80102c0b:	e8 60 16 00 00       	call   80104270 <release>
  if (log.lh.n > 0) {
80102c10:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c15:	85 c0                	test   %eax,%eax
80102c17:	0f 8e 90 00 00 00    	jle    80102cad <end_op+0xed>
80102c1d:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c20:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c25:	01 d8                	add    %ebx,%eax
80102c27:	83 c0 01             	add    $0x1,%eax
80102c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c2e:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c33:	89 04 24             	mov    %eax,(%esp)
80102c36:	e8 95 d4 ff ff       	call   801000d0 <bread>
80102c3b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c3d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102c44:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c47:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c4b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c50:	89 04 24             	mov    %eax,(%esp)
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c58:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c5f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c60:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c62:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c65:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c69:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c6c:	89 04 24             	mov    %eax,(%esp)
80102c6f:	e8 ec 16 00 00       	call   80104360 <memmove>
    bwrite(to);  // write the log
80102c74:	89 34 24             	mov    %esi,(%esp)
80102c77:	e8 24 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c7c:	89 3c 24             	mov    %edi,(%esp)
80102c7f:	e8 5c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c84:	89 34 24             	mov    %esi,(%esp)
80102c87:	e8 54 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c8c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c92:	7c 8c                	jl     80102c20 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c94:	e8 a7 fd ff ff       	call   80102a40 <write_head>
    install_trans(); // Now install writes to home locations
80102c99:	e8 02 fd ff ff       	call   801029a0 <install_trans>
    log.lh.n = 0;
80102c9e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ca5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ca8:	e8 93 fd ff ff       	call   80102a40 <write_head>
    acquire(&log.lock);
80102cad:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cb4:	e8 c7 14 00 00       	call   80104180 <acquire>
    log.committing = 0;
80102cb9:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102cc0:	00 00 00 
    wakeup(&log);
80102cc3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cca:	e8 01 11 00 00       	call   80103dd0 <wakeup>
    release(&log.lock);
80102ccf:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cd6:	e8 95 15 00 00       	call   80104270 <release>
}
80102cdb:	83 c4 1c             	add    $0x1c,%esp
80102cde:	5b                   	pop    %ebx
80102cdf:	5e                   	pop    %esi
80102ce0:	5f                   	pop    %edi
80102ce1:	5d                   	pop    %ebp
80102ce2:	c3                   	ret    
    panic("log.committing");
80102ce3:	c7 04 24 c4 72 10 80 	movl   $0x801072c4,(%esp)
80102cea:	e8 71 d6 ff ff       	call   80100360 <panic>
80102cef:	90                   	nop

80102cf0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	53                   	push   %ebx
80102cf4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cf7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102cfc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cff:	83 f8 1d             	cmp    $0x1d,%eax
80102d02:	0f 8f 98 00 00 00    	jg     80102da0 <log_write+0xb0>
80102d08:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102d0e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d11:	39 d0                	cmp    %edx,%eax
80102d13:	0f 8d 87 00 00 00    	jge    80102da0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d19:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d1e:	85 c0                	test   %eax,%eax
80102d20:	0f 8e 86 00 00 00    	jle    80102dac <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d26:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d2d:	e8 4e 14 00 00       	call   80104180 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d32:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d38:	83 fa 00             	cmp    $0x0,%edx
80102d3b:	7e 54                	jle    80102d91 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d3d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d40:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d42:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d48:	75 0f                	jne    80102d59 <log_write+0x69>
80102d4a:	eb 3c                	jmp    80102d88 <log_write+0x98>
80102d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d50:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d57:	74 2f                	je     80102d88 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d59:	83 c0 01             	add    $0x1,%eax
80102d5c:	39 d0                	cmp    %edx,%eax
80102d5e:	75 f0                	jne    80102d50 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d60:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d67:	83 c2 01             	add    $0x1,%edx
80102d6a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d70:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d73:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d7a:	83 c4 14             	add    $0x14,%esp
80102d7d:	5b                   	pop    %ebx
80102d7e:	5d                   	pop    %ebp
  release(&log.lock);
80102d7f:	e9 ec 14 00 00       	jmp    80104270 <release>
80102d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d88:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d8f:	eb df                	jmp    80102d70 <log_write+0x80>
80102d91:	8b 43 08             	mov    0x8(%ebx),%eax
80102d94:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d99:	75 d5                	jne    80102d70 <log_write+0x80>
80102d9b:	eb ca                	jmp    80102d67 <log_write+0x77>
80102d9d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102da0:	c7 04 24 d3 72 10 80 	movl   $0x801072d3,(%esp)
80102da7:	e8 b4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102dac:	c7 04 24 e9 72 10 80 	movl   $0x801072e9,(%esp)
80102db3:	e8 a8 d5 ff ff       	call   80100360 <panic>
80102db8:	66 90                	xchg   %ax,%ax
80102dba:	66 90                	xchg   %ax,%ax
80102dbc:	66 90                	xchg   %ax,%ax
80102dbe:	66 90                	xchg   %ax,%ax

80102dc0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	53                   	push   %ebx
80102dc4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102dc7:	e8 f4 08 00 00       	call   801036c0 <cpuid>
80102dcc:	89 c3                	mov    %eax,%ebx
80102dce:	e8 ed 08 00 00       	call   801036c0 <cpuid>
80102dd3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102dd7:	c7 04 24 04 73 10 80 	movl   $0x80107304,(%esp)
80102dde:	89 44 24 04          	mov    %eax,0x4(%esp)
80102de2:	e8 69 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102de7:	e8 34 27 00 00       	call   80105520 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dec:	e8 4f 08 00 00       	call   80103640 <mycpu>
80102df1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102df3:	b8 01 00 00 00       	mov    $0x1,%eax
80102df8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102dff:	e8 9c 0b 00 00       	call   801039a0 <scheduler>
80102e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102e10 <mpenter>:
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e16:	e8 c5 37 00 00       	call   801065e0 <switchkvm>
  seginit();
80102e1b:	e8 80 36 00 00       	call   801064a0 <seginit>
  lapicinit();
80102e20:	e8 8b f8 ff ff       	call   801026b0 <lapicinit>
  mpmain();
80102e25:	e8 96 ff ff ff       	call   80102dc0 <mpmain>
80102e2a:	66 90                	xchg   %ax,%ax
80102e2c:	66 90                	xchg   %ax,%ax
80102e2e:	66 90                	xchg   %ax,%ax

80102e30 <main>:
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e34:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102e39:	83 e4 f0             	and    $0xfffffff0,%esp
80102e3c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e3f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e46:	80 
80102e47:	c7 04 24 f4 58 11 80 	movl   $0x801158f4,(%esp)
80102e4e:	e8 cd f5 ff ff       	call   80102420 <kinit1>
  kvmalloc();      // kernel page table
80102e53:	e8 38 3c 00 00       	call   80106a90 <kvmalloc>
  mpinit();        // detect other processors
80102e58:	e8 73 01 00 00       	call   80102fd0 <mpinit>
80102e5d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e60:	e8 4b f8 ff ff       	call   801026b0 <lapicinit>
  seginit();       // segment descriptors
80102e65:	e8 36 36 00 00       	call   801064a0 <seginit>
  picinit();       // disable pic
80102e6a:	e8 21 03 00 00       	call   80103190 <picinit>
80102e6f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e70:	e8 cb f3 ff ff       	call   80102240 <ioapicinit>
  consoleinit();   // console hardware
80102e75:	e8 d6 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e7a:	e8 c1 29 00 00       	call   80105840 <uartinit>
80102e7f:	90                   	nop
  pinit();         // process table
80102e80:	e8 9b 07 00 00       	call   80103620 <pinit>
  shminit();       // shared memory
80102e85:	e8 f6 3e 00 00       	call   80106d80 <shminit>
  tvinit();        // trap vectors
80102e8a:	e8 f1 25 00 00       	call   80105480 <tvinit>
80102e8f:	90                   	nop
  binit();         // buffer cache
80102e90:	e8 ab d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e95:	e8 e6 de ff ff       	call   80100d80 <fileinit>
  ideinit();       // disk 
80102e9a:	e8 a1 f1 ff ff       	call   80102040 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e9f:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102ea6:	00 
80102ea7:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102eae:	80 
80102eaf:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102eb6:	e8 a5 14 00 00       	call   80104360 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102ebb:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ec2:	00 00 00 
80102ec5:	05 80 27 11 80       	add    $0x80112780,%eax
80102eca:	39 d8                	cmp    %ebx,%eax
80102ecc:	76 65                	jbe    80102f33 <main+0x103>
80102ece:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102ed0:	e8 6b 07 00 00       	call   80103640 <mycpu>
80102ed5:	39 d8                	cmp    %ebx,%eax
80102ed7:	74 41                	je     80102f1a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ed9:	e8 02 f6 ff ff       	call   801024e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102ede:	c7 05 f8 6f 00 80 10 	movl   $0x80102e10,0x80006ff8
80102ee5:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ee8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102eef:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ef2:	05 00 10 00 00       	add    $0x1000,%eax
80102ef7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102efc:	0f b6 03             	movzbl (%ebx),%eax
80102eff:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f06:	00 
80102f07:	89 04 24             	mov    %eax,(%esp)
80102f0a:	e8 e1 f8 ff ff       	call   801027f0 <lapicstartap>
80102f0f:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f10:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f16:	85 c0                	test   %eax,%eax
80102f18:	74 f6                	je     80102f10 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f1a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f21:	00 00 00 
80102f24:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f2a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f2f:	39 c3                	cmp    %eax,%ebx
80102f31:	72 9d                	jb     80102ed0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f33:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f3a:	8e 
80102f3b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f42:	e8 49 f5 ff ff       	call   80102490 <kinit2>
  userinit();      // first user process
80102f47:	e8 c4 07 00 00       	call   80103710 <userinit>
  mpmain();        // finish this processor's setup
80102f4c:	e8 6f fe ff ff       	call   80102dc0 <mpmain>
80102f51:	66 90                	xchg   %ax,%ax
80102f53:	66 90                	xchg   %ax,%ax
80102f55:	66 90                	xchg   %ax,%ax
80102f57:	66 90                	xchg   %ax,%ax
80102f59:	66 90                	xchg   %ax,%ax
80102f5b:	66 90                	xchg   %ax,%ax
80102f5d:	66 90                	xchg   %ax,%ax
80102f5f:	90                   	nop

80102f60 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f64:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f6a:	53                   	push   %ebx
  e = addr+len;
80102f6b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f6e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f71:	39 de                	cmp    %ebx,%esi
80102f73:	73 3c                	jae    80102fb1 <mpsearch1+0x51>
80102f75:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f78:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f7f:	00 
80102f80:	c7 44 24 04 18 73 10 	movl   $0x80107318,0x4(%esp)
80102f87:	80 
80102f88:	89 34 24             	mov    %esi,(%esp)
80102f8b:	e8 80 13 00 00       	call   80104310 <memcmp>
80102f90:	85 c0                	test   %eax,%eax
80102f92:	75 16                	jne    80102faa <mpsearch1+0x4a>
80102f94:	31 c9                	xor    %ecx,%ecx
80102f96:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f98:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f9c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f9f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102fa1:	83 fa 10             	cmp    $0x10,%edx
80102fa4:	75 f2                	jne    80102f98 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fa6:	84 c9                	test   %cl,%cl
80102fa8:	74 10                	je     80102fba <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102faa:	83 c6 10             	add    $0x10,%esi
80102fad:	39 f3                	cmp    %esi,%ebx
80102faf:	77 c7                	ja     80102f78 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102fb1:	83 c4 10             	add    $0x10,%esp
  return 0;
80102fb4:	31 c0                	xor    %eax,%eax
}
80102fb6:	5b                   	pop    %ebx
80102fb7:	5e                   	pop    %esi
80102fb8:	5d                   	pop    %ebp
80102fb9:	c3                   	ret    
80102fba:	83 c4 10             	add    $0x10,%esp
80102fbd:	89 f0                	mov    %esi,%eax
80102fbf:	5b                   	pop    %ebx
80102fc0:	5e                   	pop    %esi
80102fc1:	5d                   	pop    %ebp
80102fc2:	c3                   	ret    
80102fc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fd0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	57                   	push   %edi
80102fd4:	56                   	push   %esi
80102fd5:	53                   	push   %ebx
80102fd6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fd9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fe0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fe7:	c1 e0 08             	shl    $0x8,%eax
80102fea:	09 d0                	or     %edx,%eax
80102fec:	c1 e0 04             	shl    $0x4,%eax
80102fef:	85 c0                	test   %eax,%eax
80102ff1:	75 1b                	jne    8010300e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102ff3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102ffa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103001:	c1 e0 08             	shl    $0x8,%eax
80103004:	09 d0                	or     %edx,%eax
80103006:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103009:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010300e:	ba 00 04 00 00       	mov    $0x400,%edx
80103013:	e8 48 ff ff ff       	call   80102f60 <mpsearch1>
80103018:	85 c0                	test   %eax,%eax
8010301a:	89 c7                	mov    %eax,%edi
8010301c:	0f 84 22 01 00 00    	je     80103144 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103022:	8b 77 04             	mov    0x4(%edi),%esi
80103025:	85 f6                	test   %esi,%esi
80103027:	0f 84 30 01 00 00    	je     8010315d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010302d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103033:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010303a:	00 
8010303b:	c7 44 24 04 1d 73 10 	movl   $0x8010731d,0x4(%esp)
80103042:	80 
80103043:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103046:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103049:	e8 c2 12 00 00       	call   80104310 <memcmp>
8010304e:	85 c0                	test   %eax,%eax
80103050:	0f 85 07 01 00 00    	jne    8010315d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103056:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010305d:	3c 04                	cmp    $0x4,%al
8010305f:	0f 85 0b 01 00 00    	jne    80103170 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103065:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010306c:	85 c0                	test   %eax,%eax
8010306e:	74 21                	je     80103091 <mpinit+0xc1>
  sum = 0;
80103070:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103072:	31 d2                	xor    %edx,%edx
80103074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103078:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010307f:	80 
  for(i=0; i<len; i++)
80103080:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103083:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103085:	39 d0                	cmp    %edx,%eax
80103087:	7f ef                	jg     80103078 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103089:	84 c9                	test   %cl,%cl
8010308b:	0f 85 cc 00 00 00    	jne    8010315d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103091:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103094:	85 c0                	test   %eax,%eax
80103096:	0f 84 c1 00 00 00    	je     8010315d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010309c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
801030a2:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
801030a7:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030ac:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801030b3:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801030b9:	03 55 e4             	add    -0x1c(%ebp),%edx
801030bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030c0:	39 c2                	cmp    %eax,%edx
801030c2:	76 1b                	jbe    801030df <mpinit+0x10f>
801030c4:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
801030c7:	80 f9 04             	cmp    $0x4,%cl
801030ca:	77 74                	ja     80103140 <mpinit+0x170>
801030cc:	ff 24 8d 5c 73 10 80 	jmp    *-0x7fef8ca4(,%ecx,4)
801030d3:	90                   	nop
801030d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030d8:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030db:	39 c2                	cmp    %eax,%edx
801030dd:	77 e5                	ja     801030c4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030df:	85 db                	test   %ebx,%ebx
801030e1:	0f 84 93 00 00 00    	je     8010317a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030e7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030eb:	74 12                	je     801030ff <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ed:	ba 22 00 00 00       	mov    $0x22,%edx
801030f2:	b8 70 00 00 00       	mov    $0x70,%eax
801030f7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030f8:	b2 23                	mov    $0x23,%dl
801030fa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030fb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030fe:	ee                   	out    %al,(%dx)
  }
}
801030ff:	83 c4 1c             	add    $0x1c,%esp
80103102:	5b                   	pop    %ebx
80103103:	5e                   	pop    %esi
80103104:	5f                   	pop    %edi
80103105:	5d                   	pop    %ebp
80103106:	c3                   	ret    
80103107:	90                   	nop
      if(ncpu < NCPU) {
80103108:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010310e:	83 fe 07             	cmp    $0x7,%esi
80103111:	7f 17                	jg     8010312a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103113:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103117:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
8010311d:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103124:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
8010312a:	83 c0 14             	add    $0x14,%eax
      continue;
8010312d:	eb 91                	jmp    801030c0 <mpinit+0xf0>
8010312f:	90                   	nop
      ioapicid = ioapic->apicno;
80103130:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103134:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103137:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
8010313d:	eb 81                	jmp    801030c0 <mpinit+0xf0>
8010313f:	90                   	nop
      ismp = 0;
80103140:	31 db                	xor    %ebx,%ebx
80103142:	eb 83                	jmp    801030c7 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
80103144:	ba 00 00 01 00       	mov    $0x10000,%edx
80103149:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010314e:	e8 0d fe ff ff       	call   80102f60 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103153:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103155:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103157:	0f 85 c5 fe ff ff    	jne    80103022 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010315d:	c7 04 24 22 73 10 80 	movl   $0x80107322,(%esp)
80103164:	e8 f7 d1 ff ff       	call   80100360 <panic>
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103170:	3c 01                	cmp    $0x1,%al
80103172:	0f 84 ed fe ff ff    	je     80103065 <mpinit+0x95>
80103178:	eb e3                	jmp    8010315d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010317a:	c7 04 24 3c 73 10 80 	movl   $0x8010733c,(%esp)
80103181:	e8 da d1 ff ff       	call   80100360 <panic>
80103186:	66 90                	xchg   %ax,%ax
80103188:	66 90                	xchg   %ax,%ax
8010318a:	66 90                	xchg   %ax,%ax
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103190:	55                   	push   %ebp
80103191:	ba 21 00 00 00       	mov    $0x21,%edx
80103196:	89 e5                	mov    %esp,%ebp
80103198:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010319d:	ee                   	out    %al,(%dx)
8010319e:	b2 a1                	mov    $0xa1,%dl
801031a0:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031a1:	5d                   	pop    %ebp
801031a2:	c3                   	ret    
801031a3:	66 90                	xchg   %ax,%ax
801031a5:	66 90                	xchg   %ax,%ax
801031a7:	66 90                	xchg   %ax,%ax
801031a9:	66 90                	xchg   %ax,%ax
801031ab:	66 90                	xchg   %ax,%ax
801031ad:	66 90                	xchg   %ax,%ax
801031af:	90                   	nop

801031b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	57                   	push   %edi
801031b4:	56                   	push   %esi
801031b5:	53                   	push   %ebx
801031b6:	83 ec 1c             	sub    $0x1c,%esp
801031b9:	8b 75 08             	mov    0x8(%ebp),%esi
801031bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031c5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031cb:	e8 d0 db ff ff       	call   80100da0 <filealloc>
801031d0:	85 c0                	test   %eax,%eax
801031d2:	89 06                	mov    %eax,(%esi)
801031d4:	0f 84 a4 00 00 00    	je     8010327e <pipealloc+0xce>
801031da:	e8 c1 db ff ff       	call   80100da0 <filealloc>
801031df:	85 c0                	test   %eax,%eax
801031e1:	89 03                	mov    %eax,(%ebx)
801031e3:	0f 84 87 00 00 00    	je     80103270 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031e9:	e8 f2 f2 ff ff       	call   801024e0 <kalloc>
801031ee:	85 c0                	test   %eax,%eax
801031f0:	89 c7                	mov    %eax,%edi
801031f2:	74 7c                	je     80103270 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031f4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031fb:	00 00 00 
  p->writeopen = 1;
801031fe:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103205:	00 00 00 
  p->nwrite = 0;
80103208:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010320f:	00 00 00 
  p->nread = 0;
80103212:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103219:	00 00 00 
  initlock(&p->lock, "pipe");
8010321c:	89 04 24             	mov    %eax,(%esp)
8010321f:	c7 44 24 04 70 73 10 	movl   $0x80107370,0x4(%esp)
80103226:	80 
80103227:	e8 64 0e 00 00       	call   80104090 <initlock>
  (*f0)->type = FD_PIPE;
8010322c:	8b 06                	mov    (%esi),%eax
8010322e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103234:	8b 06                	mov    (%esi),%eax
80103236:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010323a:	8b 06                	mov    (%esi),%eax
8010323c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103240:	8b 06                	mov    (%esi),%eax
80103242:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103245:	8b 03                	mov    (%ebx),%eax
80103247:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010324d:	8b 03                	mov    (%ebx),%eax
8010324f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103253:	8b 03                	mov    (%ebx),%eax
80103255:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103259:	8b 03                	mov    (%ebx),%eax
  return 0;
8010325b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010325d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103260:	83 c4 1c             	add    $0x1c,%esp
80103263:	89 d8                	mov    %ebx,%eax
80103265:	5b                   	pop    %ebx
80103266:	5e                   	pop    %esi
80103267:	5f                   	pop    %edi
80103268:	5d                   	pop    %ebp
80103269:	c3                   	ret    
8010326a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103270:	8b 06                	mov    (%esi),%eax
80103272:	85 c0                	test   %eax,%eax
80103274:	74 08                	je     8010327e <pipealloc+0xce>
    fileclose(*f0);
80103276:	89 04 24             	mov    %eax,(%esp)
80103279:	e8 e2 db ff ff       	call   80100e60 <fileclose>
  if(*f1)
8010327e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103280:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103285:	85 c0                	test   %eax,%eax
80103287:	74 d7                	je     80103260 <pipealloc+0xb0>
    fileclose(*f1);
80103289:	89 04 24             	mov    %eax,(%esp)
8010328c:	e8 cf db ff ff       	call   80100e60 <fileclose>
}
80103291:	83 c4 1c             	add    $0x1c,%esp
80103294:	89 d8                	mov    %ebx,%eax
80103296:	5b                   	pop    %ebx
80103297:	5e                   	pop    %esi
80103298:	5f                   	pop    %edi
80103299:	5d                   	pop    %ebp
8010329a:	c3                   	ret    
8010329b:	90                   	nop
8010329c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032a0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	56                   	push   %esi
801032a4:	53                   	push   %ebx
801032a5:	83 ec 10             	sub    $0x10,%esp
801032a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032ae:	89 1c 24             	mov    %ebx,(%esp)
801032b1:	e8 ca 0e 00 00       	call   80104180 <acquire>
  if(writable){
801032b6:	85 f6                	test   %esi,%esi
801032b8:	74 3e                	je     801032f8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801032ba:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801032c0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032c7:	00 00 00 
    wakeup(&p->nread);
801032ca:	89 04 24             	mov    %eax,(%esp)
801032cd:	e8 fe 0a 00 00       	call   80103dd0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032d2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032d8:	85 d2                	test   %edx,%edx
801032da:	75 0a                	jne    801032e6 <pipeclose+0x46>
801032dc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032e2:	85 c0                	test   %eax,%eax
801032e4:	74 32                	je     80103318 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032e9:	83 c4 10             	add    $0x10,%esp
801032ec:	5b                   	pop    %ebx
801032ed:	5e                   	pop    %esi
801032ee:	5d                   	pop    %ebp
    release(&p->lock);
801032ef:	e9 7c 0f 00 00       	jmp    80104270 <release>
801032f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032f8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032fe:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103305:	00 00 00 
    wakeup(&p->nwrite);
80103308:	89 04 24             	mov    %eax,(%esp)
8010330b:	e8 c0 0a 00 00       	call   80103dd0 <wakeup>
80103310:	eb c0                	jmp    801032d2 <pipeclose+0x32>
80103312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
80103318:	89 1c 24             	mov    %ebx,(%esp)
8010331b:	e8 50 0f 00 00       	call   80104270 <release>
    kfree((char*)p);
80103320:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103323:	83 c4 10             	add    $0x10,%esp
80103326:	5b                   	pop    %ebx
80103327:	5e                   	pop    %esi
80103328:	5d                   	pop    %ebp
    kfree((char*)p);
80103329:	e9 02 f0 ff ff       	jmp    80102330 <kfree>
8010332e:	66 90                	xchg   %ax,%ax

80103330 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	57                   	push   %edi
80103334:	56                   	push   %esi
80103335:	53                   	push   %ebx
80103336:	83 ec 1c             	sub    $0x1c,%esp
80103339:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010333c:	89 1c 24             	mov    %ebx,(%esp)
8010333f:	e8 3c 0e 00 00       	call   80104180 <acquire>
  for(i = 0; i < n; i++){
80103344:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103347:	85 c9                	test   %ecx,%ecx
80103349:	0f 8e b2 00 00 00    	jle    80103401 <pipewrite+0xd1>
8010334f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103352:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103358:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010335e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103364:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103367:	03 4d 10             	add    0x10(%ebp),%ecx
8010336a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010336d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103373:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103379:	39 c8                	cmp    %ecx,%eax
8010337b:	74 38                	je     801033b5 <pipewrite+0x85>
8010337d:	eb 55                	jmp    801033d4 <pipewrite+0xa4>
8010337f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103380:	e8 5b 03 00 00       	call   801036e0 <myproc>
80103385:	8b 40 24             	mov    0x24(%eax),%eax
80103388:	85 c0                	test   %eax,%eax
8010338a:	75 33                	jne    801033bf <pipewrite+0x8f>
      wakeup(&p->nread);
8010338c:	89 3c 24             	mov    %edi,(%esp)
8010338f:	e8 3c 0a 00 00       	call   80103dd0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103394:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103398:	89 34 24             	mov    %esi,(%esp)
8010339b:	e8 a0 08 00 00       	call   80103c40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033a0:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033a6:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033ac:	05 00 02 00 00       	add    $0x200,%eax
801033b1:	39 c2                	cmp    %eax,%edx
801033b3:	75 23                	jne    801033d8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
801033b5:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033bb:	85 d2                	test   %edx,%edx
801033bd:	75 c1                	jne    80103380 <pipewrite+0x50>
        release(&p->lock);
801033bf:	89 1c 24             	mov    %ebx,(%esp)
801033c2:	e8 a9 0e 00 00       	call   80104270 <release>
        return -1;
801033c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033cc:	83 c4 1c             	add    $0x1c,%esp
801033cf:	5b                   	pop    %ebx
801033d0:	5e                   	pop    %esi
801033d1:	5f                   	pop    %edi
801033d2:	5d                   	pop    %ebp
801033d3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033d4:	89 c2                	mov    %eax,%edx
801033d6:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033db:	8d 42 01             	lea    0x1(%edx),%eax
801033de:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033e4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033ea:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033ee:	0f b6 09             	movzbl (%ecx),%ecx
801033f1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801033f5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033f8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033fb:	0f 85 6c ff ff ff    	jne    8010336d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103401:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103407:	89 04 24             	mov    %eax,(%esp)
8010340a:	e8 c1 09 00 00       	call   80103dd0 <wakeup>
  release(&p->lock);
8010340f:	89 1c 24             	mov    %ebx,(%esp)
80103412:	e8 59 0e 00 00       	call   80104270 <release>
  return n;
80103417:	8b 45 10             	mov    0x10(%ebp),%eax
8010341a:	eb b0                	jmp    801033cc <pipewrite+0x9c>
8010341c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103420 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	57                   	push   %edi
80103424:	56                   	push   %esi
80103425:	53                   	push   %ebx
80103426:	83 ec 1c             	sub    $0x1c,%esp
80103429:	8b 75 08             	mov    0x8(%ebp),%esi
8010342c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010342f:	89 34 24             	mov    %esi,(%esp)
80103432:	e8 49 0d 00 00       	call   80104180 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103437:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010343d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103443:	75 5b                	jne    801034a0 <piperead+0x80>
80103445:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010344b:	85 db                	test   %ebx,%ebx
8010344d:	74 51                	je     801034a0 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010344f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103455:	eb 25                	jmp    8010347c <piperead+0x5c>
80103457:	90                   	nop
80103458:	89 74 24 04          	mov    %esi,0x4(%esp)
8010345c:	89 1c 24             	mov    %ebx,(%esp)
8010345f:	e8 dc 07 00 00       	call   80103c40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103464:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010346a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103470:	75 2e                	jne    801034a0 <piperead+0x80>
80103472:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103478:	85 d2                	test   %edx,%edx
8010347a:	74 24                	je     801034a0 <piperead+0x80>
    if(myproc()->killed){
8010347c:	e8 5f 02 00 00       	call   801036e0 <myproc>
80103481:	8b 48 24             	mov    0x24(%eax),%ecx
80103484:	85 c9                	test   %ecx,%ecx
80103486:	74 d0                	je     80103458 <piperead+0x38>
      release(&p->lock);
80103488:	89 34 24             	mov    %esi,(%esp)
8010348b:	e8 e0 0d 00 00       	call   80104270 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103490:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103493:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103498:	5b                   	pop    %ebx
80103499:	5e                   	pop    %esi
8010349a:	5f                   	pop    %edi
8010349b:	5d                   	pop    %ebp
8010349c:	c3                   	ret    
8010349d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034a0:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
801034a3:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034a5:	85 d2                	test   %edx,%edx
801034a7:	7f 2b                	jg     801034d4 <piperead+0xb4>
801034a9:	eb 31                	jmp    801034dc <piperead+0xbc>
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
801034b0:	8d 48 01             	lea    0x1(%eax),%ecx
801034b3:	25 ff 01 00 00       	and    $0x1ff,%eax
801034b8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801034be:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801034c3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034c6:	83 c3 01             	add    $0x1,%ebx
801034c9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801034cc:	74 0e                	je     801034dc <piperead+0xbc>
    if(p->nread == p->nwrite)
801034ce:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034d4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034da:	75 d4                	jne    801034b0 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034dc:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034e2:	89 04 24             	mov    %eax,(%esp)
801034e5:	e8 e6 08 00 00       	call   80103dd0 <wakeup>
  release(&p->lock);
801034ea:	89 34 24             	mov    %esi,(%esp)
801034ed:	e8 7e 0d 00 00       	call   80104270 <release>
}
801034f2:	83 c4 1c             	add    $0x1c,%esp
  return i;
801034f5:	89 d8                	mov    %ebx,%eax
}
801034f7:	5b                   	pop    %ebx
801034f8:	5e                   	pop    %esi
801034f9:	5f                   	pop    %edi
801034fa:	5d                   	pop    %ebp
801034fb:	c3                   	ret    
801034fc:	66 90                	xchg   %ax,%ax
801034fe:	66 90                	xchg   %ax,%ax

80103500 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103504:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103509:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010350c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103513:	e8 68 0c 00 00       	call   80104180 <acquire>
80103518:	eb 11                	jmp    8010352b <allocproc+0x2b>
8010351a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103520:	83 eb 80             	sub    $0xffffff80,%ebx
80103523:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103529:	74 7d                	je     801035a8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010352b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010352e:	85 c0                	test   %eax,%eax
80103530:	75 ee                	jne    80103520 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103532:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103537:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
8010353e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103545:	8d 50 01             	lea    0x1(%eax),%edx
80103548:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010354e:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103551:	e8 1a 0d 00 00       	call   80104270 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103556:	e8 85 ef ff ff       	call   801024e0 <kalloc>
8010355b:	85 c0                	test   %eax,%eax
8010355d:	89 43 08             	mov    %eax,0x8(%ebx)
80103560:	74 5a                	je     801035bc <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103562:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103568:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010356d:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103570:	c7 40 14 75 54 10 80 	movl   $0x80105475,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103577:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010357e:	00 
8010357f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103586:	00 
80103587:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010358a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010358d:	e8 2e 0d 00 00       	call   801042c0 <memset>
  p->context->eip = (uint)forkret;
80103592:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103595:	c7 40 10 d0 35 10 80 	movl   $0x801035d0,0x10(%eax)

  return p;
8010359c:	89 d8                	mov    %ebx,%eax
}
8010359e:	83 c4 14             	add    $0x14,%esp
801035a1:	5b                   	pop    %ebx
801035a2:	5d                   	pop    %ebp
801035a3:	c3                   	ret    
801035a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801035a8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035af:	e8 bc 0c 00 00       	call   80104270 <release>
}
801035b4:	83 c4 14             	add    $0x14,%esp
  return 0;
801035b7:	31 c0                	xor    %eax,%eax
}
801035b9:	5b                   	pop    %ebx
801035ba:	5d                   	pop    %ebp
801035bb:	c3                   	ret    
    p->state = UNUSED;
801035bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035c3:	eb d9                	jmp    8010359e <allocproc+0x9e>
801035c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035d6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035dd:	e8 8e 0c 00 00       	call   80104270 <release>

  if (first) {
801035e2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035e7:	85 c0                	test   %eax,%eax
801035e9:	75 05                	jne    801035f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035eb:	c9                   	leave  
801035ec:	c3                   	ret    
801035ed:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035f7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035fe:	00 00 00 
    iinit(ROOTDEV);
80103601:	e8 aa de ff ff       	call   801014b0 <iinit>
    initlog(ROOTDEV);
80103606:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010360d:	e8 9e f4 ff ff       	call   80102ab0 <initlog>
}
80103612:	c9                   	leave  
80103613:	c3                   	ret    
80103614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010361a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103620 <pinit>:
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103626:	c7 44 24 04 75 73 10 	movl   $0x80107375,0x4(%esp)
8010362d:	80 
8010362e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103635:	e8 56 0a 00 00       	call   80104090 <initlock>
}
8010363a:	c9                   	leave  
8010363b:	c3                   	ret    
8010363c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103640 <mycpu>:
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	56                   	push   %esi
80103644:	53                   	push   %ebx
80103645:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103648:	9c                   	pushf  
80103649:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010364a:	f6 c4 02             	test   $0x2,%ah
8010364d:	75 57                	jne    801036a6 <mycpu+0x66>
  apicid = lapicid();
8010364f:	e8 4c f1 ff ff       	call   801027a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103654:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010365a:	85 f6                	test   %esi,%esi
8010365c:	7e 3c                	jle    8010369a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010365e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103665:	39 c2                	cmp    %eax,%edx
80103667:	74 2d                	je     80103696 <mycpu+0x56>
80103669:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010366e:	31 d2                	xor    %edx,%edx
80103670:	83 c2 01             	add    $0x1,%edx
80103673:	39 f2                	cmp    %esi,%edx
80103675:	74 23                	je     8010369a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103677:	0f b6 19             	movzbl (%ecx),%ebx
8010367a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103680:	39 c3                	cmp    %eax,%ebx
80103682:	75 ec                	jne    80103670 <mycpu+0x30>
      return &cpus[i];
80103684:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010368a:	83 c4 10             	add    $0x10,%esp
8010368d:	5b                   	pop    %ebx
8010368e:	5e                   	pop    %esi
8010368f:	5d                   	pop    %ebp
      return &cpus[i];
80103690:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103695:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103696:	31 d2                	xor    %edx,%edx
80103698:	eb ea                	jmp    80103684 <mycpu+0x44>
  panic("unknown apicid\n");
8010369a:	c7 04 24 7c 73 10 80 	movl   $0x8010737c,(%esp)
801036a1:	e8 ba cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
801036a6:	c7 04 24 58 74 10 80 	movl   $0x80107458,(%esp)
801036ad:	e8 ae cc ff ff       	call   80100360 <panic>
801036b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036c0 <cpuid>:
cpuid() {
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036c6:	e8 75 ff ff ff       	call   80103640 <mycpu>
}
801036cb:	c9                   	leave  
  return mycpu()-cpus;
801036cc:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036d1:	c1 f8 04             	sar    $0x4,%eax
801036d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036da:	c3                   	ret    
801036db:	90                   	nop
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036e0 <myproc>:
myproc(void) {
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	53                   	push   %ebx
801036e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036e7:	e8 54 0a 00 00       	call   80104140 <pushcli>
  c = mycpu();
801036ec:	e8 4f ff ff ff       	call   80103640 <mycpu>
  p = c->proc;
801036f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036f7:	e8 04 0b 00 00       	call   80104200 <popcli>
}
801036fc:	83 c4 04             	add    $0x4,%esp
801036ff:	89 d8                	mov    %ebx,%eax
80103701:	5b                   	pop    %ebx
80103702:	5d                   	pop    %ebp
80103703:	c3                   	ret    
80103704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010370a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103710 <userinit>:
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	53                   	push   %ebx
80103714:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103717:	e8 e4 fd ff ff       	call   80103500 <allocproc>
8010371c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010371e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103723:	e8 d8 32 00 00       	call   80106a00 <setupkvm>
80103728:	85 c0                	test   %eax,%eax
8010372a:	89 43 04             	mov    %eax,0x4(%ebx)
8010372d:	0f 84 d4 00 00 00    	je     80103807 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103733:	89 04 24             	mov    %eax,(%esp)
80103736:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010373d:	00 
8010373e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103745:	80 
80103746:	e8 c5 2f 00 00       	call   80106710 <inituvm>
  p->sz = PGSIZE;
8010374b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103751:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103758:	00 
80103759:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103760:	00 
80103761:	8b 43 18             	mov    0x18(%ebx),%eax
80103764:	89 04 24             	mov    %eax,(%esp)
80103767:	e8 54 0b 00 00       	call   801042c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010376c:	8b 43 18             	mov    0x18(%ebx),%eax
8010376f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103774:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103779:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010377d:	8b 43 18             	mov    0x18(%ebx),%eax
80103780:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103784:	8b 43 18             	mov    0x18(%ebx),%eax
80103787:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010378b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010378f:	8b 43 18             	mov    0x18(%ebx),%eax
80103792:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103796:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010379a:	8b 43 18             	mov    0x18(%ebx),%eax
8010379d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801037a4:	8b 43 18             	mov    0x18(%ebx),%eax
801037a7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801037ae:	8b 43 18             	mov    0x18(%ebx),%eax
801037b1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801037b8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801037bb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037c2:	00 
801037c3:	c7 44 24 04 a5 73 10 	movl   $0x801073a5,0x4(%esp)
801037ca:	80 
801037cb:	89 04 24             	mov    %eax,(%esp)
801037ce:	e8 cd 0c 00 00       	call   801044a0 <safestrcpy>
  p->cwd = namei("/");
801037d3:	c7 04 24 ae 73 10 80 	movl   $0x801073ae,(%esp)
801037da:	e8 61 e7 ff ff       	call   80101f40 <namei>
801037df:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801037e2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037e9:	e8 92 09 00 00       	call   80104180 <acquire>
  p->state = RUNNABLE;
801037ee:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801037f5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037fc:	e8 6f 0a 00 00       	call   80104270 <release>
}
80103801:	83 c4 14             	add    $0x14,%esp
80103804:	5b                   	pop    %ebx
80103805:	5d                   	pop    %ebp
80103806:	c3                   	ret    
    panic("userinit: out of memory?");
80103807:	c7 04 24 8c 73 10 80 	movl   $0x8010738c,(%esp)
8010380e:	e8 4d cb ff ff       	call   80100360 <panic>
80103813:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103820 <growproc>:
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	83 ec 10             	sub    $0x10,%esp
80103828:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010382b:	e8 b0 fe ff ff       	call   801036e0 <myproc>
  if(n > 0){
80103830:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
80103833:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103835:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103837:	7e 2f                	jle    80103868 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103839:	01 c6                	add    %eax,%esi
8010383b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010383f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103843:	8b 43 04             	mov    0x4(%ebx),%eax
80103846:	89 04 24             	mov    %eax,(%esp)
80103849:	e8 12 30 00 00       	call   80106860 <allocuvm>
8010384e:	85 c0                	test   %eax,%eax
80103850:	74 36                	je     80103888 <growproc+0x68>
  curproc->sz = sz;
80103852:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103854:	89 1c 24             	mov    %ebx,(%esp)
80103857:	e8 a4 2d 00 00       	call   80106600 <switchuvm>
  return 0;
8010385c:	31 c0                	xor    %eax,%eax
}
8010385e:	83 c4 10             	add    $0x10,%esp
80103861:	5b                   	pop    %ebx
80103862:	5e                   	pop    %esi
80103863:	5d                   	pop    %ebp
80103864:	c3                   	ret    
80103865:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103868:	74 e8                	je     80103852 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010386a:	01 c6                	add    %eax,%esi
8010386c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103870:	89 44 24 04          	mov    %eax,0x4(%esp)
80103874:	8b 43 04             	mov    0x4(%ebx),%eax
80103877:	89 04 24             	mov    %eax,(%esp)
8010387a:	e8 e1 30 00 00       	call   80106960 <deallocuvm>
8010387f:	85 c0                	test   %eax,%eax
80103881:	75 cf                	jne    80103852 <growproc+0x32>
80103883:	90                   	nop
80103884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010388d:	eb cf                	jmp    8010385e <growproc+0x3e>
8010388f:	90                   	nop

80103890 <fork>:
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	57                   	push   %edi
80103894:	56                   	push   %esi
80103895:	53                   	push   %ebx
80103896:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103899:	e8 42 fe ff ff       	call   801036e0 <myproc>
8010389e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801038a0:	e8 5b fc ff ff       	call   80103500 <allocproc>
801038a5:	85 c0                	test   %eax,%eax
801038a7:	89 c7                	mov    %eax,%edi
801038a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038ac:	0f 84 bc 00 00 00    	je     8010396e <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801038b2:	8b 03                	mov    (%ebx),%eax
801038b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801038b8:	8b 43 04             	mov    0x4(%ebx),%eax
801038bb:	89 04 24             	mov    %eax,(%esp)
801038be:	e8 1d 32 00 00       	call   80106ae0 <copyuvm>
801038c3:	85 c0                	test   %eax,%eax
801038c5:	89 47 04             	mov    %eax,0x4(%edi)
801038c8:	0f 84 a7 00 00 00    	je     80103975 <fork+0xe5>
  np->sz = curproc->sz;
801038ce:	8b 03                	mov    (%ebx),%eax
801038d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038d3:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801038d5:	8b 79 18             	mov    0x18(%ecx),%edi
801038d8:	89 c8                	mov    %ecx,%eax
  np->parent = curproc;
801038da:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801038dd:	8b 73 18             	mov    0x18(%ebx),%esi
801038e0:	b9 13 00 00 00       	mov    $0x13,%ecx
801038e5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038e7:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801038e9:	8b 40 18             	mov    0x18(%eax),%eax
801038ec:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038f3:	90                   	nop
801038f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801038f8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038fc:	85 c0                	test   %eax,%eax
801038fe:	74 0f                	je     8010390f <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103900:	89 04 24             	mov    %eax,(%esp)
80103903:	e8 08 d5 ff ff       	call   80100e10 <filedup>
80103908:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010390b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010390f:	83 c6 01             	add    $0x1,%esi
80103912:	83 fe 10             	cmp    $0x10,%esi
80103915:	75 e1                	jne    801038f8 <fork+0x68>
  np->cwd = idup(curproc->cwd);
80103917:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010391a:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010391d:	89 04 24             	mov    %eax,(%esp)
80103920:	e8 9b dd ff ff       	call   801016c0 <idup>
80103925:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103928:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010392b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010392e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103932:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103939:	00 
8010393a:	89 04 24             	mov    %eax,(%esp)
8010393d:	e8 5e 0b 00 00       	call   801044a0 <safestrcpy>
  pid = np->pid;
80103942:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103945:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010394c:	e8 2f 08 00 00       	call   80104180 <acquire>
  np->state = RUNNABLE;
80103951:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103958:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010395f:	e8 0c 09 00 00       	call   80104270 <release>
  return pid;
80103964:	89 d8                	mov    %ebx,%eax
}
80103966:	83 c4 1c             	add    $0x1c,%esp
80103969:	5b                   	pop    %ebx
8010396a:	5e                   	pop    %esi
8010396b:	5f                   	pop    %edi
8010396c:	5d                   	pop    %ebp
8010396d:	c3                   	ret    
    return -1;
8010396e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103973:	eb f1                	jmp    80103966 <fork+0xd6>
    kfree(np->kstack);
80103975:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103978:	8b 47 08             	mov    0x8(%edi),%eax
8010397b:	89 04 24             	mov    %eax,(%esp)
8010397e:	e8 ad e9 ff ff       	call   80102330 <kfree>
    return -1;
80103983:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103988:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010398f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103996:	eb ce                	jmp    80103966 <fork+0xd6>
80103998:	90                   	nop
80103999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039a0 <scheduler>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	57                   	push   %edi
801039a4:	56                   	push   %esi
801039a5:	53                   	push   %ebx
801039a6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801039a9:	e8 92 fc ff ff       	call   80103640 <mycpu>
801039ae:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801039b0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039b7:	00 00 00 
801039ba:	8d 78 04             	lea    0x4(%eax),%edi
801039bd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801039c0:	fb                   	sti    
    acquire(&ptable.lock);
801039c1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039c8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
801039cd:	e8 ae 07 00 00       	call   80104180 <acquire>
801039d2:	eb 0f                	jmp    801039e3 <scheduler+0x43>
801039d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d8:	83 eb 80             	sub    $0xffffff80,%ebx
801039db:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801039e1:	74 45                	je     80103a28 <scheduler+0x88>
      if(p->state != RUNNABLE)
801039e3:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039e7:	75 ef                	jne    801039d8 <scheduler+0x38>
      c->proc = p;
801039e9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039ef:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039f2:	83 eb 80             	sub    $0xffffff80,%ebx
      switchuvm(p);
801039f5:	e8 06 2c 00 00       	call   80106600 <switchuvm>
      swtch(&(c->scheduler), p->context);
801039fa:	8b 43 9c             	mov    -0x64(%ebx),%eax
      p->state = RUNNING;
801039fd:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)
      swtch(&(c->scheduler), p->context);
80103a04:	89 3c 24             	mov    %edi,(%esp)
80103a07:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a0b:	e8 eb 0a 00 00       	call   801044fb <swtch>
      switchkvm();
80103a10:	e8 cb 2b 00 00       	call   801065e0 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a15:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      c->proc = 0;
80103a1b:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a22:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a25:	75 bc                	jne    801039e3 <scheduler+0x43>
80103a27:	90                   	nop
    release(&ptable.lock);
80103a28:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a2f:	e8 3c 08 00 00       	call   80104270 <release>
  }
80103a34:	eb 8a                	jmp    801039c0 <scheduler+0x20>
80103a36:	8d 76 00             	lea    0x0(%esi),%esi
80103a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a40 <sched>:
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	56                   	push   %esi
80103a44:	53                   	push   %ebx
80103a45:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103a48:	e8 93 fc ff ff       	call   801036e0 <myproc>
  if(!holding(&ptable.lock))
80103a4d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103a54:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103a56:	e8 b5 06 00 00       	call   80104110 <holding>
80103a5b:	85 c0                	test   %eax,%eax
80103a5d:	74 4f                	je     80103aae <sched+0x6e>
  if(mycpu()->ncli != 1)
80103a5f:	e8 dc fb ff ff       	call   80103640 <mycpu>
80103a64:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a6b:	75 65                	jne    80103ad2 <sched+0x92>
  if(p->state == RUNNING)
80103a6d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a71:	74 53                	je     80103ac6 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a73:	9c                   	pushf  
80103a74:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a75:	f6 c4 02             	test   $0x2,%ah
80103a78:	75 40                	jne    80103aba <sched+0x7a>
  intena = mycpu()->intena;
80103a7a:	e8 c1 fb ff ff       	call   80103640 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a7f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103a82:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a88:	e8 b3 fb ff ff       	call   80103640 <mycpu>
80103a8d:	8b 40 04             	mov    0x4(%eax),%eax
80103a90:	89 1c 24             	mov    %ebx,(%esp)
80103a93:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a97:	e8 5f 0a 00 00       	call   801044fb <swtch>
  mycpu()->intena = intena;
80103a9c:	e8 9f fb ff ff       	call   80103640 <mycpu>
80103aa1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103aa7:	83 c4 10             	add    $0x10,%esp
80103aaa:	5b                   	pop    %ebx
80103aab:	5e                   	pop    %esi
80103aac:	5d                   	pop    %ebp
80103aad:	c3                   	ret    
    panic("sched ptable.lock");
80103aae:	c7 04 24 b0 73 10 80 	movl   $0x801073b0,(%esp)
80103ab5:	e8 a6 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103aba:	c7 04 24 dc 73 10 80 	movl   $0x801073dc,(%esp)
80103ac1:	e8 9a c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103ac6:	c7 04 24 ce 73 10 80 	movl   $0x801073ce,(%esp)
80103acd:	e8 8e c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103ad2:	c7 04 24 c2 73 10 80 	movl   $0x801073c2,(%esp)
80103ad9:	e8 82 c8 ff ff       	call   80100360 <panic>
80103ade:	66 90                	xchg   %ax,%ax

80103ae0 <exit>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	56                   	push   %esi
  if(curproc == initproc)
80103ae4:	31 f6                	xor    %esi,%esi
{
80103ae6:	53                   	push   %ebx
80103ae7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103aea:	e8 f1 fb ff ff       	call   801036e0 <myproc>
  if(curproc == initproc)
80103aef:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103af5:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103af7:	0f 84 ea 00 00 00    	je     80103be7 <exit+0x107>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103b00:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b04:	85 c0                	test   %eax,%eax
80103b06:	74 10                	je     80103b18 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103b08:	89 04 24             	mov    %eax,(%esp)
80103b0b:	e8 50 d3 ff ff       	call   80100e60 <fileclose>
      curproc->ofile[fd] = 0;
80103b10:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103b17:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103b18:	83 c6 01             	add    $0x1,%esi
80103b1b:	83 fe 10             	cmp    $0x10,%esi
80103b1e:	75 e0                	jne    80103b00 <exit+0x20>
  begin_op();
80103b20:	e8 2b f0 ff ff       	call   80102b50 <begin_op>
  iput(curproc->cwd);
80103b25:	8b 43 68             	mov    0x68(%ebx),%eax
80103b28:	89 04 24             	mov    %eax,(%esp)
80103b2b:	e8 e0 dc ff ff       	call   80101810 <iput>
  end_op();
80103b30:	e8 8b f0 ff ff       	call   80102bc0 <end_op>
  curproc->cwd = 0;
80103b35:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103b3c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b43:	e8 38 06 00 00       	call   80104180 <acquire>
  wakeup1(curproc->parent);
80103b48:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b4b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b50:	eb 11                	jmp    80103b63 <exit+0x83>
80103b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b58:	83 ea 80             	sub    $0xffffff80,%edx
80103b5b:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b61:	74 1d                	je     80103b80 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103b63:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b67:	75 ef                	jne    80103b58 <exit+0x78>
80103b69:	3b 42 20             	cmp    0x20(%edx),%eax
80103b6c:	75 ea                	jne    80103b58 <exit+0x78>
      p->state = RUNNABLE;
80103b6e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b75:	83 ea 80             	sub    $0xffffff80,%edx
80103b78:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b7e:	75 e3                	jne    80103b63 <exit+0x83>
      p->parent = initproc;
80103b80:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b85:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b8a:	eb 0f                	jmp    80103b9b <exit+0xbb>
80103b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b90:	83 e9 80             	sub    $0xffffff80,%ecx
80103b93:	81 f9 54 4d 11 80    	cmp    $0x80114d54,%ecx
80103b99:	74 34                	je     80103bcf <exit+0xef>
    if(p->parent == curproc){
80103b9b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b9e:	75 f0                	jne    80103b90 <exit+0xb0>
      if(p->state == ZOMBIE)
80103ba0:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103ba4:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103ba7:	75 e7                	jne    80103b90 <exit+0xb0>
80103ba9:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103bae:	eb 0b                	jmp    80103bbb <exit+0xdb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bb0:	83 ea 80             	sub    $0xffffff80,%edx
80103bb3:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103bb9:	74 d5                	je     80103b90 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103bbb:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103bbf:	75 ef                	jne    80103bb0 <exit+0xd0>
80103bc1:	3b 42 20             	cmp    0x20(%edx),%eax
80103bc4:	75 ea                	jne    80103bb0 <exit+0xd0>
      p->state = RUNNABLE;
80103bc6:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103bcd:	eb e1                	jmp    80103bb0 <exit+0xd0>
  curproc->state = ZOMBIE;
80103bcf:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103bd6:	e8 65 fe ff ff       	call   80103a40 <sched>
  panic("zombie exit");
80103bdb:	c7 04 24 fd 73 10 80 	movl   $0x801073fd,(%esp)
80103be2:	e8 79 c7 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103be7:	c7 04 24 f0 73 10 80 	movl   $0x801073f0,(%esp)
80103bee:	e8 6d c7 ff ff       	call   80100360 <panic>
80103bf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c00 <yield>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c06:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c0d:	e8 6e 05 00 00       	call   80104180 <acquire>
  myproc()->state = RUNNABLE;
80103c12:	e8 c9 fa ff ff       	call   801036e0 <myproc>
80103c17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103c1e:	e8 1d fe ff ff       	call   80103a40 <sched>
  release(&ptable.lock);
80103c23:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c2a:	e8 41 06 00 00       	call   80104270 <release>
}
80103c2f:	c9                   	leave  
80103c30:	c3                   	ret    
80103c31:	eb 0d                	jmp    80103c40 <sleep>
80103c33:	90                   	nop
80103c34:	90                   	nop
80103c35:	90                   	nop
80103c36:	90                   	nop
80103c37:	90                   	nop
80103c38:	90                   	nop
80103c39:	90                   	nop
80103c3a:	90                   	nop
80103c3b:	90                   	nop
80103c3c:	90                   	nop
80103c3d:	90                   	nop
80103c3e:	90                   	nop
80103c3f:	90                   	nop

80103c40 <sleep>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 1c             	sub    $0x1c,%esp
80103c49:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103c4f:	e8 8c fa ff ff       	call   801036e0 <myproc>
  if(p == 0)
80103c54:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103c56:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103c58:	0f 84 7c 00 00 00    	je     80103cda <sleep+0x9a>
  if(lk == 0)
80103c5e:	85 f6                	test   %esi,%esi
80103c60:	74 6c                	je     80103cce <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c62:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c68:	74 46                	je     80103cb0 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c6a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c71:	e8 0a 05 00 00       	call   80104180 <acquire>
    release(lk);
80103c76:	89 34 24             	mov    %esi,(%esp)
80103c79:	e8 f2 05 00 00       	call   80104270 <release>
  p->chan = chan;
80103c7e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c81:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103c88:	e8 b3 fd ff ff       	call   80103a40 <sched>
  p->chan = 0;
80103c8d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103c94:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c9b:	e8 d0 05 00 00       	call   80104270 <release>
    acquire(lk);
80103ca0:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103ca3:	83 c4 1c             	add    $0x1c,%esp
80103ca6:	5b                   	pop    %ebx
80103ca7:	5e                   	pop    %esi
80103ca8:	5f                   	pop    %edi
80103ca9:	5d                   	pop    %ebp
    acquire(lk);
80103caa:	e9 d1 04 00 00       	jmp    80104180 <acquire>
80103caf:	90                   	nop
  p->chan = chan;
80103cb0:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103cb3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103cba:	e8 81 fd ff ff       	call   80103a40 <sched>
  p->chan = 0;
80103cbf:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103cc6:	83 c4 1c             	add    $0x1c,%esp
80103cc9:	5b                   	pop    %ebx
80103cca:	5e                   	pop    %esi
80103ccb:	5f                   	pop    %edi
80103ccc:	5d                   	pop    %ebp
80103ccd:	c3                   	ret    
    panic("sleep without lk");
80103cce:	c7 04 24 0f 74 10 80 	movl   $0x8010740f,(%esp)
80103cd5:	e8 86 c6 ff ff       	call   80100360 <panic>
    panic("sleep");
80103cda:	c7 04 24 09 74 10 80 	movl   $0x80107409,(%esp)
80103ce1:	e8 7a c6 ff ff       	call   80100360 <panic>
80103ce6:	8d 76 00             	lea    0x0(%esi),%esi
80103ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cf0 <wait>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	56                   	push   %esi
80103cf4:	53                   	push   %ebx
80103cf5:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103cf8:	e8 e3 f9 ff ff       	call   801036e0 <myproc>
  acquire(&ptable.lock);
80103cfd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103d04:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103d06:	e8 75 04 00 00       	call   80104180 <acquire>
    havekids = 0;
80103d0b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d0d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103d12:	eb 0f                	jmp    80103d23 <wait+0x33>
80103d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d18:	83 eb 80             	sub    $0xffffff80,%ebx
80103d1b:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103d21:	74 1d                	je     80103d40 <wait+0x50>
      if(p->parent != curproc)
80103d23:	39 73 14             	cmp    %esi,0x14(%ebx)
80103d26:	75 f0                	jne    80103d18 <wait+0x28>
      if(p->state == ZOMBIE){
80103d28:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103d2c:	74 2f                	je     80103d5d <wait+0x6d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d2e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103d31:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d36:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103d3c:	75 e5                	jne    80103d23 <wait+0x33>
80103d3e:	66 90                	xchg   %ax,%ax
    if(!havekids || curproc->killed){
80103d40:	85 c0                	test   %eax,%eax
80103d42:	74 6e                	je     80103db2 <wait+0xc2>
80103d44:	8b 46 24             	mov    0x24(%esi),%eax
80103d47:	85 c0                	test   %eax,%eax
80103d49:	75 67                	jne    80103db2 <wait+0xc2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d4b:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d52:	80 
80103d53:	89 34 24             	mov    %esi,(%esp)
80103d56:	e8 e5 fe ff ff       	call   80103c40 <sleep>
  }
80103d5b:	eb ae                	jmp    80103d0b <wait+0x1b>
        kfree(p->kstack);
80103d5d:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103d60:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d63:	89 04 24             	mov    %eax,(%esp)
80103d66:	e8 c5 e5 ff ff       	call   80102330 <kfree>
        freevm(p->pgdir);
80103d6b:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103d6e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d75:	89 04 24             	mov    %eax,(%esp)
80103d78:	e8 03 2c 00 00       	call   80106980 <freevm>
        release(&ptable.lock);
80103d7d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103d84:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d8b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103d92:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103d96:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103d9d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103da4:	e8 c7 04 00 00       	call   80104270 <release>
}
80103da9:	83 c4 10             	add    $0x10,%esp
        return pid;
80103dac:	89 f0                	mov    %esi,%eax
}
80103dae:	5b                   	pop    %ebx
80103daf:	5e                   	pop    %esi
80103db0:	5d                   	pop    %ebp
80103db1:	c3                   	ret    
      release(&ptable.lock);
80103db2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103db9:	e8 b2 04 00 00       	call   80104270 <release>
}
80103dbe:	83 c4 10             	add    $0x10,%esp
      return -1;
80103dc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103dc6:	5b                   	pop    %ebx
80103dc7:	5e                   	pop    %esi
80103dc8:	5d                   	pop    %ebp
80103dc9:	c3                   	ret    
80103dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103dd0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	53                   	push   %ebx
80103dd4:	83 ec 14             	sub    $0x14,%esp
80103dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103dda:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103de1:	e8 9a 03 00 00       	call   80104180 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103de6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103deb:	eb 0d                	jmp    80103dfa <wakeup+0x2a>
80103ded:	8d 76 00             	lea    0x0(%esi),%esi
80103df0:	83 e8 80             	sub    $0xffffff80,%eax
80103df3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103df8:	74 1e                	je     80103e18 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103dfa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dfe:	75 f0                	jne    80103df0 <wakeup+0x20>
80103e00:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e03:	75 eb                	jne    80103df0 <wakeup+0x20>
      p->state = RUNNABLE;
80103e05:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e0c:	83 e8 80             	sub    $0xffffff80,%eax
80103e0f:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e14:	75 e4                	jne    80103dfa <wakeup+0x2a>
80103e16:	66 90                	xchg   %ax,%ax
  wakeup1(chan);
  release(&ptable.lock);
80103e18:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103e1f:	83 c4 14             	add    $0x14,%esp
80103e22:	5b                   	pop    %ebx
80103e23:	5d                   	pop    %ebp
  release(&ptable.lock);
80103e24:	e9 47 04 00 00       	jmp    80104270 <release>
80103e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e30 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	53                   	push   %ebx
80103e34:	83 ec 14             	sub    $0x14,%esp
80103e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e3a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e41:	e8 3a 03 00 00       	call   80104180 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e46:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e4b:	eb 0d                	jmp    80103e5a <kill+0x2a>
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi
80103e50:	83 e8 80             	sub    $0xffffff80,%eax
80103e53:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e58:	74 36                	je     80103e90 <kill+0x60>
    if(p->pid == pid){
80103e5a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e5d:	75 f1                	jne    80103e50 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e5f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103e63:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103e6a:	74 14                	je     80103e80 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e6c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e73:	e8 f8 03 00 00       	call   80104270 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e78:	83 c4 14             	add    $0x14,%esp
      return 0;
80103e7b:	31 c0                	xor    %eax,%eax
}
80103e7d:	5b                   	pop    %ebx
80103e7e:	5d                   	pop    %ebp
80103e7f:	c3                   	ret    
        p->state = RUNNABLE;
80103e80:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e87:	eb e3                	jmp    80103e6c <kill+0x3c>
80103e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103e90:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e97:	e8 d4 03 00 00       	call   80104270 <release>
}
80103e9c:	83 c4 14             	add    $0x14,%esp
  return -1;
80103e9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ea4:	5b                   	pop    %ebx
80103ea5:	5d                   	pop    %ebp
80103ea6:	c3                   	ret    
80103ea7:	89 f6                	mov    %esi,%esi
80103ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103eb0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	57                   	push   %edi
80103eb4:	56                   	push   %esi
80103eb5:	53                   	push   %ebx
80103eb6:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103ebb:	83 ec 4c             	sub    $0x4c,%esp
80103ebe:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ec1:	eb 20                	jmp    80103ee3 <procdump+0x33>
80103ec3:	90                   	nop
80103ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103ec8:	c7 04 24 9f 77 10 80 	movl   $0x8010779f,(%esp)
80103ecf:	e8 7c c7 ff ff       	call   80100650 <cprintf>
80103ed4:	83 eb 80             	sub    $0xffffff80,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed7:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80103edd:	0f 84 8d 00 00 00    	je     80103f70 <procdump+0xc0>
    if(p->state == UNUSED)
80103ee3:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103ee6:	85 c0                	test   %eax,%eax
80103ee8:	74 ea                	je     80103ed4 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103eea:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103eed:	ba 20 74 10 80       	mov    $0x80107420,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ef2:	77 11                	ja     80103f05 <procdump+0x55>
80103ef4:	8b 14 85 80 74 10 80 	mov    -0x7fef8b80(,%eax,4),%edx
      state = "???";
80103efb:	b8 20 74 10 80       	mov    $0x80107420,%eax
80103f00:	85 d2                	test   %edx,%edx
80103f02:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103f05:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103f08:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103f0c:	89 54 24 08          	mov    %edx,0x8(%esp)
80103f10:	c7 04 24 24 74 10 80 	movl   $0x80107424,(%esp)
80103f17:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f1b:	e8 30 c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103f20:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f24:	75 a2                	jne    80103ec8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f26:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f29:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f2d:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f30:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f33:	8b 40 0c             	mov    0xc(%eax),%eax
80103f36:	83 c0 08             	add    $0x8,%eax
80103f39:	89 04 24             	mov    %eax,(%esp)
80103f3c:	e8 6f 01 00 00       	call   801040b0 <getcallerpcs>
80103f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103f48:	8b 17                	mov    (%edi),%edx
80103f4a:	85 d2                	test   %edx,%edx
80103f4c:	0f 84 76 ff ff ff    	je     80103ec8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f52:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f56:	83 c7 04             	add    $0x4,%edi
80103f59:	c7 04 24 41 6e 10 80 	movl   $0x80106e41,(%esp)
80103f60:	e8 eb c6 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f65:	39 f7                	cmp    %esi,%edi
80103f67:	75 df                	jne    80103f48 <procdump+0x98>
80103f69:	e9 5a ff ff ff       	jmp    80103ec8 <procdump+0x18>
80103f6e:	66 90                	xchg   %ax,%ax
  }
}
80103f70:	83 c4 4c             	add    $0x4c,%esp
80103f73:	5b                   	pop    %ebx
80103f74:	5e                   	pop    %esi
80103f75:	5f                   	pop    %edi
80103f76:	5d                   	pop    %ebp
80103f77:	c3                   	ret    
80103f78:	66 90                	xchg   %ax,%ax
80103f7a:	66 90                	xchg   %ax,%ax
80103f7c:	66 90                	xchg   %ax,%ax
80103f7e:	66 90                	xchg   %ax,%ax

80103f80 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	53                   	push   %ebx
80103f84:	83 ec 14             	sub    $0x14,%esp
80103f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f8a:	c7 44 24 04 98 74 10 	movl   $0x80107498,0x4(%esp)
80103f91:	80 
80103f92:	8d 43 04             	lea    0x4(%ebx),%eax
80103f95:	89 04 24             	mov    %eax,(%esp)
80103f98:	e8 f3 00 00 00       	call   80104090 <initlock>
  lk->name = name;
80103f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103fa0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fa6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80103fad:	89 43 38             	mov    %eax,0x38(%ebx)
}
80103fb0:	83 c4 14             	add    $0x14,%esp
80103fb3:	5b                   	pop    %ebx
80103fb4:	5d                   	pop    %ebp
80103fb5:	c3                   	ret    
80103fb6:	8d 76 00             	lea    0x0(%esi),%esi
80103fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fc0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	56                   	push   %esi
80103fc4:	53                   	push   %ebx
80103fc5:	83 ec 10             	sub    $0x10,%esp
80103fc8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fcb:	8d 73 04             	lea    0x4(%ebx),%esi
80103fce:	89 34 24             	mov    %esi,(%esp)
80103fd1:	e8 aa 01 00 00       	call   80104180 <acquire>
  while (lk->locked) {
80103fd6:	8b 13                	mov    (%ebx),%edx
80103fd8:	85 d2                	test   %edx,%edx
80103fda:	74 16                	je     80103ff2 <acquiresleep+0x32>
80103fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103fe0:	89 74 24 04          	mov    %esi,0x4(%esp)
80103fe4:	89 1c 24             	mov    %ebx,(%esp)
80103fe7:	e8 54 fc ff ff       	call   80103c40 <sleep>
  while (lk->locked) {
80103fec:	8b 03                	mov    (%ebx),%eax
80103fee:	85 c0                	test   %eax,%eax
80103ff0:	75 ee                	jne    80103fe0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80103ff2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103ff8:	e8 e3 f6 ff ff       	call   801036e0 <myproc>
80103ffd:	8b 40 10             	mov    0x10(%eax),%eax
80104000:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104003:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104006:	83 c4 10             	add    $0x10,%esp
80104009:	5b                   	pop    %ebx
8010400a:	5e                   	pop    %esi
8010400b:	5d                   	pop    %ebp
  release(&lk->lk);
8010400c:	e9 5f 02 00 00       	jmp    80104270 <release>
80104011:	eb 0d                	jmp    80104020 <releasesleep>
80104013:	90                   	nop
80104014:	90                   	nop
80104015:	90                   	nop
80104016:	90                   	nop
80104017:	90                   	nop
80104018:	90                   	nop
80104019:	90                   	nop
8010401a:	90                   	nop
8010401b:	90                   	nop
8010401c:	90                   	nop
8010401d:	90                   	nop
8010401e:	90                   	nop
8010401f:	90                   	nop

80104020 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	56                   	push   %esi
80104024:	53                   	push   %ebx
80104025:	83 ec 10             	sub    $0x10,%esp
80104028:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010402b:	8d 73 04             	lea    0x4(%ebx),%esi
8010402e:	89 34 24             	mov    %esi,(%esp)
80104031:	e8 4a 01 00 00       	call   80104180 <acquire>
  lk->locked = 0;
80104036:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010403c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104043:	89 1c 24             	mov    %ebx,(%esp)
80104046:	e8 85 fd ff ff       	call   80103dd0 <wakeup>
  release(&lk->lk);
8010404b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010404e:	83 c4 10             	add    $0x10,%esp
80104051:	5b                   	pop    %ebx
80104052:	5e                   	pop    %esi
80104053:	5d                   	pop    %ebp
  release(&lk->lk);
80104054:	e9 17 02 00 00       	jmp    80104270 <release>
80104059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104060 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	56                   	push   %esi
80104064:	53                   	push   %ebx
80104065:	83 ec 10             	sub    $0x10,%esp
80104068:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010406b:	8d 73 04             	lea    0x4(%ebx),%esi
8010406e:	89 34 24             	mov    %esi,(%esp)
80104071:	e8 0a 01 00 00       	call   80104180 <acquire>
  r = lk->locked;
80104076:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104078:	89 34 24             	mov    %esi,(%esp)
8010407b:	e8 f0 01 00 00       	call   80104270 <release>
  return r;
}
80104080:	83 c4 10             	add    $0x10,%esp
80104083:	89 d8                	mov    %ebx,%eax
80104085:	5b                   	pop    %ebx
80104086:	5e                   	pop    %esi
80104087:	5d                   	pop    %ebp
80104088:	c3                   	ret    
80104089:	66 90                	xchg   %ax,%ax
8010408b:	66 90                	xchg   %ax,%ax
8010408d:	66 90                	xchg   %ax,%ax
8010408f:	90                   	nop

80104090 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104096:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104099:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010409f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801040a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801040a9:	5d                   	pop    %ebp
801040aa:	c3                   	ret    
801040ab:	90                   	nop
801040ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040b3:	8b 45 08             	mov    0x8(%ebp),%eax
{
801040b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801040b9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801040ba:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801040bd:	31 c0                	xor    %eax,%eax
801040bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801040c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040cc:	77 1a                	ja     801040e8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801040d1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801040d4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801040d7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801040d9:	83 f8 0a             	cmp    $0xa,%eax
801040dc:	75 e2                	jne    801040c0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801040de:	5b                   	pop    %ebx
801040df:	5d                   	pop    %ebp
801040e0:	c3                   	ret    
801040e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801040e8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801040ef:	83 c0 01             	add    $0x1,%eax
801040f2:	83 f8 0a             	cmp    $0xa,%eax
801040f5:	74 e7                	je     801040de <getcallerpcs+0x2e>
    pcs[i] = 0;
801040f7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801040fe:	83 c0 01             	add    $0x1,%eax
80104101:	83 f8 0a             	cmp    $0xa,%eax
80104104:	75 e2                	jne    801040e8 <getcallerpcs+0x38>
80104106:	eb d6                	jmp    801040de <getcallerpcs+0x2e>
80104108:	90                   	nop
80104109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104110 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104110:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
80104111:	31 c0                	xor    %eax,%eax
{
80104113:	89 e5                	mov    %esp,%ebp
80104115:	53                   	push   %ebx
80104116:	83 ec 04             	sub    $0x4,%esp
80104119:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010411c:	8b 0a                	mov    (%edx),%ecx
8010411e:	85 c9                	test   %ecx,%ecx
80104120:	74 10                	je     80104132 <holding+0x22>
80104122:	8b 5a 08             	mov    0x8(%edx),%ebx
80104125:	e8 16 f5 ff ff       	call   80103640 <mycpu>
8010412a:	39 c3                	cmp    %eax,%ebx
8010412c:	0f 94 c0             	sete   %al
8010412f:	0f b6 c0             	movzbl %al,%eax
}
80104132:	83 c4 04             	add    $0x4,%esp
80104135:	5b                   	pop    %ebx
80104136:	5d                   	pop    %ebp
80104137:	c3                   	ret    
80104138:	90                   	nop
80104139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104140 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 04             	sub    $0x4,%esp
80104147:	9c                   	pushf  
80104148:	5b                   	pop    %ebx
  asm volatile("cli");
80104149:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010414a:	e8 f1 f4 ff ff       	call   80103640 <mycpu>
8010414f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104155:	85 c0                	test   %eax,%eax
80104157:	75 11                	jne    8010416a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104159:	e8 e2 f4 ff ff       	call   80103640 <mycpu>
8010415e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104164:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010416a:	e8 d1 f4 ff ff       	call   80103640 <mycpu>
8010416f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104176:	83 c4 04             	add    $0x4,%esp
80104179:	5b                   	pop    %ebx
8010417a:	5d                   	pop    %ebp
8010417b:	c3                   	ret    
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104180 <acquire>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104187:	e8 b4 ff ff ff       	call   80104140 <pushcli>
  if(holding(lk))
8010418c:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010418f:	8b 02                	mov    (%edx),%eax
80104191:	85 c0                	test   %eax,%eax
80104193:	75 43                	jne    801041d8 <acquire+0x58>
  asm volatile("lock; xchgl %0, %1" :
80104195:	b9 01 00 00 00       	mov    $0x1,%ecx
8010419a:	eb 07                	jmp    801041a3 <acquire+0x23>
8010419c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041a0:	8b 55 08             	mov    0x8(%ebp),%edx
801041a3:	89 c8                	mov    %ecx,%eax
801041a5:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
801041a8:	85 c0                	test   %eax,%eax
801041aa:	75 f4                	jne    801041a0 <acquire+0x20>
  __sync_synchronize();
801041ac:	0f ae f0             	mfence 
  lk->cpu = mycpu();
801041af:	8b 5d 08             	mov    0x8(%ebp),%ebx
801041b2:	e8 89 f4 ff ff       	call   80103640 <mycpu>
801041b7:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801041ba:	8b 45 08             	mov    0x8(%ebp),%eax
801041bd:	83 c0 0c             	add    $0xc,%eax
801041c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801041c4:	8d 45 08             	lea    0x8(%ebp),%eax
801041c7:	89 04 24             	mov    %eax,(%esp)
801041ca:	e8 e1 fe ff ff       	call   801040b0 <getcallerpcs>
}
801041cf:	83 c4 14             	add    $0x14,%esp
801041d2:	5b                   	pop    %ebx
801041d3:	5d                   	pop    %ebp
801041d4:	c3                   	ret    
801041d5:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
801041d8:	8b 5a 08             	mov    0x8(%edx),%ebx
801041db:	e8 60 f4 ff ff       	call   80103640 <mycpu>
  if(holding(lk))
801041e0:	39 c3                	cmp    %eax,%ebx
801041e2:	74 05                	je     801041e9 <acquire+0x69>
801041e4:	8b 55 08             	mov    0x8(%ebp),%edx
801041e7:	eb ac                	jmp    80104195 <acquire+0x15>
    panic("acquire");
801041e9:	c7 04 24 a3 74 10 80 	movl   $0x801074a3,(%esp)
801041f0:	e8 6b c1 ff ff       	call   80100360 <panic>
801041f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104200 <popcli>:

void
popcli(void)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104206:	9c                   	pushf  
80104207:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104208:	f6 c4 02             	test   $0x2,%ah
8010420b:	75 49                	jne    80104256 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010420d:	e8 2e f4 ff ff       	call   80103640 <mycpu>
80104212:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104218:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010421b:	85 d2                	test   %edx,%edx
8010421d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104223:	78 25                	js     8010424a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104225:	e8 16 f4 ff ff       	call   80103640 <mycpu>
8010422a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104230:	85 d2                	test   %edx,%edx
80104232:	74 04                	je     80104238 <popcli+0x38>
    sti();
}
80104234:	c9                   	leave  
80104235:	c3                   	ret    
80104236:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104238:	e8 03 f4 ff ff       	call   80103640 <mycpu>
8010423d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104243:	85 c0                	test   %eax,%eax
80104245:	74 ed                	je     80104234 <popcli+0x34>
  asm volatile("sti");
80104247:	fb                   	sti    
}
80104248:	c9                   	leave  
80104249:	c3                   	ret    
    panic("popcli");
8010424a:	c7 04 24 c2 74 10 80 	movl   $0x801074c2,(%esp)
80104251:	e8 0a c1 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104256:	c7 04 24 ab 74 10 80 	movl   $0x801074ab,(%esp)
8010425d:	e8 fe c0 ff ff       	call   80100360 <panic>
80104262:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104270 <release>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	56                   	push   %esi
80104274:	53                   	push   %ebx
80104275:	83 ec 10             	sub    $0x10,%esp
80104278:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010427b:	8b 03                	mov    (%ebx),%eax
8010427d:	85 c0                	test   %eax,%eax
8010427f:	75 0f                	jne    80104290 <release+0x20>
    panic("release");
80104281:	c7 04 24 c9 74 10 80 	movl   $0x801074c9,(%esp)
80104288:	e8 d3 c0 ff ff       	call   80100360 <panic>
8010428d:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
80104290:	8b 73 08             	mov    0x8(%ebx),%esi
80104293:	e8 a8 f3 ff ff       	call   80103640 <mycpu>
  if(!holding(lk))
80104298:	39 c6                	cmp    %eax,%esi
8010429a:	75 e5                	jne    80104281 <release+0x11>
  lk->pcs[0] = 0;
8010429c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801042a3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801042aa:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801042ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801042b3:	83 c4 10             	add    $0x10,%esp
801042b6:	5b                   	pop    %ebx
801042b7:	5e                   	pop    %esi
801042b8:	5d                   	pop    %ebp
  popcli();
801042b9:	e9 42 ff ff ff       	jmp    80104200 <popcli>
801042be:	66 90                	xchg   %ax,%ax

801042c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	8b 55 08             	mov    0x8(%ebp),%edx
801042c6:	57                   	push   %edi
801042c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801042ca:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801042cb:	f6 c2 03             	test   $0x3,%dl
801042ce:	75 05                	jne    801042d5 <memset+0x15>
801042d0:	f6 c1 03             	test   $0x3,%cl
801042d3:	74 13                	je     801042e8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801042d5:	89 d7                	mov    %edx,%edi
801042d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801042da:	fc                   	cld    
801042db:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801042dd:	5b                   	pop    %ebx
801042de:	89 d0                	mov    %edx,%eax
801042e0:	5f                   	pop    %edi
801042e1:	5d                   	pop    %ebp
801042e2:	c3                   	ret    
801042e3:	90                   	nop
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801042e8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801042ec:	c1 e9 02             	shr    $0x2,%ecx
801042ef:	89 f8                	mov    %edi,%eax
801042f1:	89 fb                	mov    %edi,%ebx
801042f3:	c1 e0 18             	shl    $0x18,%eax
801042f6:	c1 e3 10             	shl    $0x10,%ebx
801042f9:	09 d8                	or     %ebx,%eax
801042fb:	09 f8                	or     %edi,%eax
801042fd:	c1 e7 08             	shl    $0x8,%edi
80104300:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104302:	89 d7                	mov    %edx,%edi
80104304:	fc                   	cld    
80104305:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104307:	5b                   	pop    %ebx
80104308:	89 d0                	mov    %edx,%eax
8010430a:	5f                   	pop    %edi
8010430b:	5d                   	pop    %ebp
8010430c:	c3                   	ret    
8010430d:	8d 76 00             	lea    0x0(%esi),%esi

80104310 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	8b 45 10             	mov    0x10(%ebp),%eax
80104316:	57                   	push   %edi
80104317:	56                   	push   %esi
80104318:	8b 75 0c             	mov    0xc(%ebp),%esi
8010431b:	53                   	push   %ebx
8010431c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010431f:	85 c0                	test   %eax,%eax
80104321:	8d 78 ff             	lea    -0x1(%eax),%edi
80104324:	74 26                	je     8010434c <memcmp+0x3c>
    if(*s1 != *s2)
80104326:	0f b6 03             	movzbl (%ebx),%eax
80104329:	31 d2                	xor    %edx,%edx
8010432b:	0f b6 0e             	movzbl (%esi),%ecx
8010432e:	38 c8                	cmp    %cl,%al
80104330:	74 16                	je     80104348 <memcmp+0x38>
80104332:	eb 24                	jmp    80104358 <memcmp+0x48>
80104334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104338:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010433d:	83 c2 01             	add    $0x1,%edx
80104340:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104344:	38 c8                	cmp    %cl,%al
80104346:	75 10                	jne    80104358 <memcmp+0x48>
  while(n-- > 0){
80104348:	39 fa                	cmp    %edi,%edx
8010434a:	75 ec                	jne    80104338 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010434c:	5b                   	pop    %ebx
  return 0;
8010434d:	31 c0                	xor    %eax,%eax
}
8010434f:	5e                   	pop    %esi
80104350:	5f                   	pop    %edi
80104351:	5d                   	pop    %ebp
80104352:	c3                   	ret    
80104353:	90                   	nop
80104354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104358:	5b                   	pop    %ebx
      return *s1 - *s2;
80104359:	29 c8                	sub    %ecx,%eax
}
8010435b:	5e                   	pop    %esi
8010435c:	5f                   	pop    %edi
8010435d:	5d                   	pop    %ebp
8010435e:	c3                   	ret    
8010435f:	90                   	nop

80104360 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	57                   	push   %edi
80104364:	8b 45 08             	mov    0x8(%ebp),%eax
80104367:	56                   	push   %esi
80104368:	8b 75 0c             	mov    0xc(%ebp),%esi
8010436b:	53                   	push   %ebx
8010436c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010436f:	39 c6                	cmp    %eax,%esi
80104371:	73 35                	jae    801043a8 <memmove+0x48>
80104373:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104376:	39 c8                	cmp    %ecx,%eax
80104378:	73 2e                	jae    801043a8 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010437a:	85 db                	test   %ebx,%ebx
    d += n;
8010437c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010437f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104382:	74 1b                	je     8010439f <memmove+0x3f>
80104384:	f7 db                	neg    %ebx
80104386:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104389:	01 fb                	add    %edi,%ebx
8010438b:	90                   	nop
8010438c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104390:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104394:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104397:	83 ea 01             	sub    $0x1,%edx
8010439a:	83 fa ff             	cmp    $0xffffffff,%edx
8010439d:	75 f1                	jne    80104390 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010439f:	5b                   	pop    %ebx
801043a0:	5e                   	pop    %esi
801043a1:	5f                   	pop    %edi
801043a2:	5d                   	pop    %ebp
801043a3:	c3                   	ret    
801043a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801043a8:	31 d2                	xor    %edx,%edx
801043aa:	85 db                	test   %ebx,%ebx
801043ac:	74 f1                	je     8010439f <memmove+0x3f>
801043ae:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801043b0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801043b7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801043ba:	39 da                	cmp    %ebx,%edx
801043bc:	75 f2                	jne    801043b0 <memmove+0x50>
}
801043be:	5b                   	pop    %ebx
801043bf:	5e                   	pop    %esi
801043c0:	5f                   	pop    %edi
801043c1:	5d                   	pop    %ebp
801043c2:	c3                   	ret    
801043c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801043d3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801043d4:	eb 8a                	jmp    80104360 <memmove>
801043d6:	8d 76 00             	lea    0x0(%esi),%esi
801043d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043e0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	56                   	push   %esi
801043e4:	8b 75 10             	mov    0x10(%ebp),%esi
801043e7:	53                   	push   %ebx
801043e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801043eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801043ee:	85 f6                	test   %esi,%esi
801043f0:	74 30                	je     80104422 <strncmp+0x42>
801043f2:	0f b6 01             	movzbl (%ecx),%eax
801043f5:	84 c0                	test   %al,%al
801043f7:	74 2f                	je     80104428 <strncmp+0x48>
801043f9:	0f b6 13             	movzbl (%ebx),%edx
801043fc:	38 d0                	cmp    %dl,%al
801043fe:	75 46                	jne    80104446 <strncmp+0x66>
80104400:	8d 51 01             	lea    0x1(%ecx),%edx
80104403:	01 ce                	add    %ecx,%esi
80104405:	eb 14                	jmp    8010441b <strncmp+0x3b>
80104407:	90                   	nop
80104408:	0f b6 02             	movzbl (%edx),%eax
8010440b:	84 c0                	test   %al,%al
8010440d:	74 31                	je     80104440 <strncmp+0x60>
8010440f:	0f b6 19             	movzbl (%ecx),%ebx
80104412:	83 c2 01             	add    $0x1,%edx
80104415:	38 d8                	cmp    %bl,%al
80104417:	75 17                	jne    80104430 <strncmp+0x50>
    n--, p++, q++;
80104419:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
8010441b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010441d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
80104420:	75 e6                	jne    80104408 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104422:	5b                   	pop    %ebx
    return 0;
80104423:	31 c0                	xor    %eax,%eax
}
80104425:	5e                   	pop    %esi
80104426:	5d                   	pop    %ebp
80104427:	c3                   	ret    
80104428:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
8010442b:	31 c0                	xor    %eax,%eax
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
80104430:	0f b6 d3             	movzbl %bl,%edx
80104433:	29 d0                	sub    %edx,%eax
}
80104435:	5b                   	pop    %ebx
80104436:	5e                   	pop    %esi
80104437:	5d                   	pop    %ebp
80104438:	c3                   	ret    
80104439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104440:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104444:	eb ea                	jmp    80104430 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
80104446:	89 d3                	mov    %edx,%ebx
80104448:	eb e6                	jmp    80104430 <strncmp+0x50>
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104450 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	8b 45 08             	mov    0x8(%ebp),%eax
80104456:	56                   	push   %esi
80104457:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010445a:	53                   	push   %ebx
8010445b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010445e:	89 c2                	mov    %eax,%edx
80104460:	eb 19                	jmp    8010447b <strncpy+0x2b>
80104462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104468:	83 c3 01             	add    $0x1,%ebx
8010446b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010446f:	83 c2 01             	add    $0x1,%edx
80104472:	84 c9                	test   %cl,%cl
80104474:	88 4a ff             	mov    %cl,-0x1(%edx)
80104477:	74 09                	je     80104482 <strncpy+0x32>
80104479:	89 f1                	mov    %esi,%ecx
8010447b:	85 c9                	test   %ecx,%ecx
8010447d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104480:	7f e6                	jg     80104468 <strncpy+0x18>
    ;
  while(n-- > 0)
80104482:	31 c9                	xor    %ecx,%ecx
80104484:	85 f6                	test   %esi,%esi
80104486:	7e 0f                	jle    80104497 <strncpy+0x47>
    *s++ = 0;
80104488:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010448c:	89 f3                	mov    %esi,%ebx
8010448e:	83 c1 01             	add    $0x1,%ecx
80104491:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104493:	85 db                	test   %ebx,%ebx
80104495:	7f f1                	jg     80104488 <strncpy+0x38>
  return os;
}
80104497:	5b                   	pop    %ebx
80104498:	5e                   	pop    %esi
80104499:	5d                   	pop    %ebp
8010449a:	c3                   	ret    
8010449b:	90                   	nop
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044a6:	56                   	push   %esi
801044a7:	8b 45 08             	mov    0x8(%ebp),%eax
801044aa:	53                   	push   %ebx
801044ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801044ae:	85 c9                	test   %ecx,%ecx
801044b0:	7e 26                	jle    801044d8 <safestrcpy+0x38>
801044b2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801044b6:	89 c1                	mov    %eax,%ecx
801044b8:	eb 17                	jmp    801044d1 <safestrcpy+0x31>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801044c0:	83 c2 01             	add    $0x1,%edx
801044c3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801044c7:	83 c1 01             	add    $0x1,%ecx
801044ca:	84 db                	test   %bl,%bl
801044cc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801044cf:	74 04                	je     801044d5 <safestrcpy+0x35>
801044d1:	39 f2                	cmp    %esi,%edx
801044d3:	75 eb                	jne    801044c0 <safestrcpy+0x20>
    ;
  *s = 0;
801044d5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801044d8:	5b                   	pop    %ebx
801044d9:	5e                   	pop    %esi
801044da:	5d                   	pop    %ebp
801044db:	c3                   	ret    
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044e0 <strlen>:

int
strlen(const char *s)
{
801044e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801044e1:	31 c0                	xor    %eax,%eax
{
801044e3:	89 e5                	mov    %esp,%ebp
801044e5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801044e8:	80 3a 00             	cmpb   $0x0,(%edx)
801044eb:	74 0c                	je     801044f9 <strlen+0x19>
801044ed:	8d 76 00             	lea    0x0(%esi),%esi
801044f0:	83 c0 01             	add    $0x1,%eax
801044f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044f7:	75 f7                	jne    801044f0 <strlen+0x10>
    ;
  return n;
}
801044f9:	5d                   	pop    %ebp
801044fa:	c3                   	ret    

801044fb <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044ff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104503:	55                   	push   %ebp
  pushl %ebx
80104504:	53                   	push   %ebx
  pushl %esi
80104505:	56                   	push   %esi
  pushl %edi
80104506:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104507:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104509:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010450b:	5f                   	pop    %edi
  popl %esi
8010450c:	5e                   	pop    %esi
  popl %ebx
8010450d:	5b                   	pop    %ebx
  popl %ebp
8010450e:	5d                   	pop    %ebp
  ret
8010450f:	c3                   	ret    

80104510 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	8b 45 08             	mov    0x8(%ebp),%eax
//  struct proc *curproc = myproc();

  if(addr >= KERNBASE - 1|| addr+4 > KERNBASE - 1)
80104516:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
8010451b:	77 0b                	ja     80104528 <fetchint+0x18>
    return -1;
  *ip = *(int*)(addr);
8010451d:	8b 10                	mov    (%eax),%edx
8010451f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104522:	89 10                	mov    %edx,(%eax)
  return 0;
80104524:	31 c0                	xor    %eax,%eax
}
80104526:	5d                   	pop    %ebp
80104527:	c3                   	ret    
    return -1;
80104528:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010452d:	5d                   	pop    %ebp
8010452e:	c3                   	ret    
8010452f:	90                   	nop

80104530 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	8b 55 08             	mov    0x8(%ebp),%edx
  char *s, *ep;
 // struct proc *curproc = myproc();

  if(addr >= KERNBASE - 1)
80104536:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010453c:	77 21                	ja     8010455f <fetchstr+0x2f>
    return -1;
  *pp = (char*)addr;
8010453e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104541:	89 d0                	mov    %edx,%eax
80104543:	89 11                	mov    %edx,(%ecx)
  ep = (char*) KERNBASE - 1;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
80104545:	80 3a 00             	cmpb   $0x0,(%edx)
80104548:	75 0b                	jne    80104555 <fetchstr+0x25>
8010454a:	eb 1c                	jmp    80104568 <fetchstr+0x38>
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104550:	80 38 00             	cmpb   $0x0,(%eax)
80104553:	74 13                	je     80104568 <fetchstr+0x38>
  for(s = *pp; s < ep; s++){
80104555:	83 c0 01             	add    $0x1,%eax
80104558:	3d ff ff ff 7f       	cmp    $0x7fffffff,%eax
8010455d:	75 f1                	jne    80104550 <fetchstr+0x20>
    return -1;
8010455f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104564:	5d                   	pop    %ebp
80104565:	c3                   	ret    
80104566:	66 90                	xchg   %ax,%ax
      return s - *pp;
80104568:	29 d0                	sub    %edx,%eax
}
8010456a:	5d                   	pop    %ebp
8010456b:	c3                   	ret    
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104570 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104576:	e8 65 f1 ff ff       	call   801036e0 <myproc>
8010457b:	8b 55 08             	mov    0x8(%ebp),%edx
8010457e:	8b 40 18             	mov    0x18(%eax),%eax
80104581:	8b 40 44             	mov    0x44(%eax),%eax
80104584:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
  if(addr >= KERNBASE - 1|| addr+4 > KERNBASE - 1)
80104588:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
8010458d:	77 11                	ja     801045a0 <argint+0x30>
  *ip = *(int*)(addr);
8010458f:	8b 10                	mov    (%eax),%edx
80104591:	8b 45 0c             	mov    0xc(%ebp),%eax
80104594:	89 10                	mov    %edx,(%eax)
  return 0;
80104596:	31 c0                	xor    %eax,%eax
}
80104598:	c9                   	leave  
80104599:	c3                   	ret    
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801045a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045a5:	c9                   	leave  
801045a6:	c3                   	ret    
801045a7:	89 f6                	mov    %esi,%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	53                   	push   %ebx
801045b4:	83 ec 24             	sub    $0x24,%esp
801045b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  //struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
801045ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
801045bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801045c1:	8b 45 08             	mov    0x8(%ebp),%eax
801045c4:	89 04 24             	mov    %eax,(%esp)
801045c7:	e8 a4 ff ff ff       	call   80104570 <argint>
801045cc:	85 c0                	test   %eax,%eax
801045ce:	78 20                	js     801045f0 <argptr+0x40>
    return -1;
  if(size < 0 || (uint)i >= KERNBASE - 1 || (uint)i+size > KERNBASE - 1)
801045d0:	85 db                	test   %ebx,%ebx
801045d2:	78 1c                	js     801045f0 <argptr+0x40>
801045d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801045dc:	77 12                	ja     801045f0 <argptr+0x40>
801045de:	01 c3                	add    %eax,%ebx
801045e0:	78 0e                	js     801045f0 <argptr+0x40>
    return -1;
  *pp = (char*)i;
801045e2:	8b 55 0c             	mov    0xc(%ebp),%edx
801045e5:	89 02                	mov    %eax,(%edx)
  return 0;
801045e7:	31 c0                	xor    %eax,%eax
}
801045e9:	83 c4 24             	add    $0x24,%esp
801045ec:	5b                   	pop    %ebx
801045ed:	5d                   	pop    %ebp
801045ee:	c3                   	ret    
801045ef:	90                   	nop
    return -1;
801045f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045f5:	eb f2                	jmp    801045e9 <argptr+0x39>
801045f7:	89 f6                	mov    %esi,%esi
801045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104600 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104606:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104609:	89 44 24 04          	mov    %eax,0x4(%esp)
8010460d:	8b 45 08             	mov    0x8(%ebp),%eax
80104610:	89 04 24             	mov    %eax,(%esp)
80104613:	e8 58 ff ff ff       	call   80104570 <argint>
80104618:	85 c0                	test   %eax,%eax
8010461a:	78 2b                	js     80104647 <argstr+0x47>
    return -1;
  return fetchstr(addr, pp);
8010461c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  if(addr >= KERNBASE - 1)
8010461f:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104625:	77 20                	ja     80104647 <argstr+0x47>
  *pp = (char*)addr;
80104627:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010462a:	89 d0                	mov    %edx,%eax
8010462c:	89 11                	mov    %edx,(%ecx)
    if(*s == 0)
8010462e:	80 3a 00             	cmpb   $0x0,(%edx)
80104631:	75 0a                	jne    8010463d <argstr+0x3d>
80104633:	eb 1b                	jmp    80104650 <argstr+0x50>
80104635:	8d 76 00             	lea    0x0(%esi),%esi
80104638:	80 38 00             	cmpb   $0x0,(%eax)
8010463b:	74 13                	je     80104650 <argstr+0x50>
  for(s = *pp; s < ep; s++){
8010463d:	83 c0 01             	add    $0x1,%eax
80104640:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104645:	76 f1                	jbe    80104638 <argstr+0x38>
    return -1;
80104647:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010464c:	c9                   	leave  
8010464d:	c3                   	ret    
8010464e:	66 90                	xchg   %ax,%ax
      return s - *pp;
80104650:	29 d0                	sub    %edx,%eax
}
80104652:	c9                   	leave  
80104653:	c3                   	ret    
80104654:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010465a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104660 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	56                   	push   %esi
80104664:	53                   	push   %ebx
80104665:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104668:	e8 73 f0 ff ff       	call   801036e0 <myproc>

  num = curproc->tf->eax;
8010466d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104670:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104672:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104675:	8d 50 ff             	lea    -0x1(%eax),%edx
80104678:	83 fa 16             	cmp    $0x16,%edx
8010467b:	77 1b                	ja     80104698 <syscall+0x38>
8010467d:	8b 14 85 00 75 10 80 	mov    -0x7fef8b00(,%eax,4),%edx
80104684:	85 d2                	test   %edx,%edx
80104686:	74 10                	je     80104698 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104688:	ff d2                	call   *%edx
8010468a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010468d:	83 c4 10             	add    $0x10,%esp
80104690:	5b                   	pop    %ebx
80104691:	5e                   	pop    %esi
80104692:	5d                   	pop    %ebp
80104693:	c3                   	ret    
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104698:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010469c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010469f:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
801046a3:	8b 43 10             	mov    0x10(%ebx),%eax
801046a6:	c7 04 24 d1 74 10 80 	movl   $0x801074d1,(%esp)
801046ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801046b1:	e8 9a bf ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
801046b6:	8b 43 18             	mov    0x18(%ebx),%eax
801046b9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801046c0:	83 c4 10             	add    $0x10,%esp
801046c3:	5b                   	pop    %ebx
801046c4:	5e                   	pop    %esi
801046c5:	5d                   	pop    %ebp
801046c6:	c3                   	ret    
801046c7:	66 90                	xchg   %ax,%ax
801046c9:	66 90                	xchg   %ax,%ax
801046cb:	66 90                	xchg   %ax,%ax
801046cd:	66 90                	xchg   %ax,%ax
801046cf:	90                   	nop

801046d0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	53                   	push   %ebx
801046d4:	89 c3                	mov    %eax,%ebx
801046d6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
801046d9:	e8 02 f0 ff ff       	call   801036e0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801046de:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
801046e0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801046e4:	85 c9                	test   %ecx,%ecx
801046e6:	74 18                	je     80104700 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
801046e8:	83 c2 01             	add    $0x1,%edx
801046eb:	83 fa 10             	cmp    $0x10,%edx
801046ee:	75 f0                	jne    801046e0 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
801046f0:	83 c4 04             	add    $0x4,%esp
  return -1;
801046f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046f8:	5b                   	pop    %ebx
801046f9:	5d                   	pop    %ebp
801046fa:	c3                   	ret    
801046fb:	90                   	nop
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104700:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
80104704:	83 c4 04             	add    $0x4,%esp
      return fd;
80104707:	89 d0                	mov    %edx,%eax
}
80104709:	5b                   	pop    %ebx
8010470a:	5d                   	pop    %ebp
8010470b:	c3                   	ret    
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104710 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	56                   	push   %esi
80104715:	53                   	push   %ebx
80104716:	83 ec 4c             	sub    $0x4c,%esp
80104719:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010471c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010471f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104722:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104726:	89 04 24             	mov    %eax,(%esp)
{
80104729:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010472c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010472f:	e8 2c d8 ff ff       	call   80101f60 <nameiparent>
80104734:	85 c0                	test   %eax,%eax
80104736:	89 c7                	mov    %eax,%edi
80104738:	0f 84 da 00 00 00    	je     80104818 <create+0x108>
    return 0;
  ilock(dp);
8010473e:	89 04 24             	mov    %eax,(%esp)
80104741:	e8 aa cf ff ff       	call   801016f0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104746:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104749:	89 44 24 08          	mov    %eax,0x8(%esp)
8010474d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104751:	89 3c 24             	mov    %edi,(%esp)
80104754:	e8 a7 d4 ff ff       	call   80101c00 <dirlookup>
80104759:	85 c0                	test   %eax,%eax
8010475b:	89 c6                	mov    %eax,%esi
8010475d:	74 41                	je     801047a0 <create+0x90>
    iunlockput(dp);
8010475f:	89 3c 24             	mov    %edi,(%esp)
80104762:	e8 e9 d1 ff ff       	call   80101950 <iunlockput>
    ilock(ip);
80104767:	89 34 24             	mov    %esi,(%esp)
8010476a:	e8 81 cf ff ff       	call   801016f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010476f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104774:	75 12                	jne    80104788 <create+0x78>
80104776:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010477b:	89 f0                	mov    %esi,%eax
8010477d:	75 09                	jne    80104788 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010477f:	83 c4 4c             	add    $0x4c,%esp
80104782:	5b                   	pop    %ebx
80104783:	5e                   	pop    %esi
80104784:	5f                   	pop    %edi
80104785:	5d                   	pop    %ebp
80104786:	c3                   	ret    
80104787:	90                   	nop
    iunlockput(ip);
80104788:	89 34 24             	mov    %esi,(%esp)
8010478b:	e8 c0 d1 ff ff       	call   80101950 <iunlockput>
}
80104790:	83 c4 4c             	add    $0x4c,%esp
    return 0;
80104793:	31 c0                	xor    %eax,%eax
}
80104795:	5b                   	pop    %ebx
80104796:	5e                   	pop    %esi
80104797:	5f                   	pop    %edi
80104798:	5d                   	pop    %ebp
80104799:	c3                   	ret    
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
801047a0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801047a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801047a8:	8b 07                	mov    (%edi),%eax
801047aa:	89 04 24             	mov    %eax,(%esp)
801047ad:	e8 ae cd ff ff       	call   80101560 <ialloc>
801047b2:	85 c0                	test   %eax,%eax
801047b4:	89 c6                	mov    %eax,%esi
801047b6:	0f 84 bf 00 00 00    	je     8010487b <create+0x16b>
  ilock(ip);
801047bc:	89 04 24             	mov    %eax,(%esp)
801047bf:	e8 2c cf ff ff       	call   801016f0 <ilock>
  ip->major = major;
801047c4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801047c8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801047cc:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801047d0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801047d4:	b8 01 00 00 00       	mov    $0x1,%eax
801047d9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801047dd:	89 34 24             	mov    %esi,(%esp)
801047e0:	e8 4b ce ff ff       	call   80101630 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801047e5:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801047ea:	74 34                	je     80104820 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801047ec:	8b 46 04             	mov    0x4(%esi),%eax
801047ef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047f3:	89 3c 24             	mov    %edi,(%esp)
801047f6:	89 44 24 08          	mov    %eax,0x8(%esp)
801047fa:	e8 61 d6 ff ff       	call   80101e60 <dirlink>
801047ff:	85 c0                	test   %eax,%eax
80104801:	78 6c                	js     8010486f <create+0x15f>
  iunlockput(dp);
80104803:	89 3c 24             	mov    %edi,(%esp)
80104806:	e8 45 d1 ff ff       	call   80101950 <iunlockput>
}
8010480b:	83 c4 4c             	add    $0x4c,%esp
  return ip;
8010480e:	89 f0                	mov    %esi,%eax
}
80104810:	5b                   	pop    %ebx
80104811:	5e                   	pop    %esi
80104812:	5f                   	pop    %edi
80104813:	5d                   	pop    %ebp
80104814:	c3                   	ret    
80104815:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80104818:	31 c0                	xor    %eax,%eax
8010481a:	e9 60 ff ff ff       	jmp    8010477f <create+0x6f>
8010481f:	90                   	nop
    dp->nlink++;  // for ".."
80104820:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104825:	89 3c 24             	mov    %edi,(%esp)
80104828:	e8 03 ce ff ff       	call   80101630 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010482d:	8b 46 04             	mov    0x4(%esi),%eax
80104830:	c7 44 24 04 7c 75 10 	movl   $0x8010757c,0x4(%esp)
80104837:	80 
80104838:	89 34 24             	mov    %esi,(%esp)
8010483b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010483f:	e8 1c d6 ff ff       	call   80101e60 <dirlink>
80104844:	85 c0                	test   %eax,%eax
80104846:	78 1b                	js     80104863 <create+0x153>
80104848:	8b 47 04             	mov    0x4(%edi),%eax
8010484b:	c7 44 24 04 7b 75 10 	movl   $0x8010757b,0x4(%esp)
80104852:	80 
80104853:	89 34 24             	mov    %esi,(%esp)
80104856:	89 44 24 08          	mov    %eax,0x8(%esp)
8010485a:	e8 01 d6 ff ff       	call   80101e60 <dirlink>
8010485f:	85 c0                	test   %eax,%eax
80104861:	79 89                	jns    801047ec <create+0xdc>
      panic("create dots");
80104863:	c7 04 24 6f 75 10 80 	movl   $0x8010756f,(%esp)
8010486a:	e8 f1 ba ff ff       	call   80100360 <panic>
    panic("create: dirlink");
8010486f:	c7 04 24 7e 75 10 80 	movl   $0x8010757e,(%esp)
80104876:	e8 e5 ba ff ff       	call   80100360 <panic>
    panic("create: ialloc");
8010487b:	c7 04 24 60 75 10 80 	movl   $0x80107560,(%esp)
80104882:	e8 d9 ba ff ff       	call   80100360 <panic>
80104887:	89 f6                	mov    %esi,%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104890 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	89 c6                	mov    %eax,%esi
80104896:	53                   	push   %ebx
80104897:	89 d3                	mov    %edx,%ebx
80104899:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
8010489c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010489f:	89 44 24 04          	mov    %eax,0x4(%esp)
801048a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048aa:	e8 c1 fc ff ff       	call   80104570 <argint>
801048af:	85 c0                	test   %eax,%eax
801048b1:	78 2d                	js     801048e0 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801048b3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048b7:	77 27                	ja     801048e0 <argfd.constprop.0+0x50>
801048b9:	e8 22 ee ff ff       	call   801036e0 <myproc>
801048be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048c1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801048c5:	85 c0                	test   %eax,%eax
801048c7:	74 17                	je     801048e0 <argfd.constprop.0+0x50>
  if(pfd)
801048c9:	85 f6                	test   %esi,%esi
801048cb:	74 02                	je     801048cf <argfd.constprop.0+0x3f>
    *pfd = fd;
801048cd:	89 16                	mov    %edx,(%esi)
  if(pf)
801048cf:	85 db                	test   %ebx,%ebx
801048d1:	74 1d                	je     801048f0 <argfd.constprop.0+0x60>
    *pf = f;
801048d3:	89 03                	mov    %eax,(%ebx)
  return 0;
801048d5:	31 c0                	xor    %eax,%eax
}
801048d7:	83 c4 20             	add    $0x20,%esp
801048da:	5b                   	pop    %ebx
801048db:	5e                   	pop    %esi
801048dc:	5d                   	pop    %ebp
801048dd:	c3                   	ret    
801048de:	66 90                	xchg   %ax,%ax
801048e0:	83 c4 20             	add    $0x20,%esp
    return -1;
801048e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048e8:	5b                   	pop    %ebx
801048e9:	5e                   	pop    %esi
801048ea:	5d                   	pop    %ebp
801048eb:	c3                   	ret    
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
801048f0:	31 c0                	xor    %eax,%eax
801048f2:	eb e3                	jmp    801048d7 <argfd.constprop.0+0x47>
801048f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104900 <sys_dup>:
{
80104900:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104901:	31 c0                	xor    %eax,%eax
{
80104903:	89 e5                	mov    %esp,%ebp
80104905:	53                   	push   %ebx
80104906:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
80104909:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010490c:	e8 7f ff ff ff       	call   80104890 <argfd.constprop.0>
80104911:	85 c0                	test   %eax,%eax
80104913:	78 23                	js     80104938 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104915:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104918:	e8 b3 fd ff ff       	call   801046d0 <fdalloc>
8010491d:	85 c0                	test   %eax,%eax
8010491f:	89 c3                	mov    %eax,%ebx
80104921:	78 15                	js     80104938 <sys_dup+0x38>
  filedup(f);
80104923:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104926:	89 04 24             	mov    %eax,(%esp)
80104929:	e8 e2 c4 ff ff       	call   80100e10 <filedup>
  return fd;
8010492e:	89 d8                	mov    %ebx,%eax
}
80104930:	83 c4 24             	add    $0x24,%esp
80104933:	5b                   	pop    %ebx
80104934:	5d                   	pop    %ebp
80104935:	c3                   	ret    
80104936:	66 90                	xchg   %ax,%ax
    return -1;
80104938:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010493d:	eb f1                	jmp    80104930 <sys_dup+0x30>
8010493f:	90                   	nop

80104940 <sys_read>:
{
80104940:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104941:	31 c0                	xor    %eax,%eax
{
80104943:	89 e5                	mov    %esp,%ebp
80104945:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104948:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010494b:	e8 40 ff ff ff       	call   80104890 <argfd.constprop.0>
80104950:	85 c0                	test   %eax,%eax
80104952:	78 54                	js     801049a8 <sys_read+0x68>
80104954:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104957:	89 44 24 04          	mov    %eax,0x4(%esp)
8010495b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104962:	e8 09 fc ff ff       	call   80104570 <argint>
80104967:	85 c0                	test   %eax,%eax
80104969:	78 3d                	js     801049a8 <sys_read+0x68>
8010496b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010496e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104975:	89 44 24 08          	mov    %eax,0x8(%esp)
80104979:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010497c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104980:	e8 2b fc ff ff       	call   801045b0 <argptr>
80104985:	85 c0                	test   %eax,%eax
80104987:	78 1f                	js     801049a8 <sys_read+0x68>
  return fileread(f, p, n);
80104989:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010498c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104990:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104993:	89 44 24 04          	mov    %eax,0x4(%esp)
80104997:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010499a:	89 04 24             	mov    %eax,(%esp)
8010499d:	e8 ce c5 ff ff       	call   80100f70 <fileread>
}
801049a2:	c9                   	leave  
801049a3:	c3                   	ret    
801049a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049ad:	c9                   	leave  
801049ae:	c3                   	ret    
801049af:	90                   	nop

801049b0 <sys_write>:
{
801049b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049b1:	31 c0                	xor    %eax,%eax
{
801049b3:	89 e5                	mov    %esp,%ebp
801049b5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801049bb:	e8 d0 fe ff ff       	call   80104890 <argfd.constprop.0>
801049c0:	85 c0                	test   %eax,%eax
801049c2:	78 54                	js     80104a18 <sys_write+0x68>
801049c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801049cb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801049d2:	e8 99 fb ff ff       	call   80104570 <argint>
801049d7:	85 c0                	test   %eax,%eax
801049d9:	78 3d                	js     80104a18 <sys_write+0x68>
801049db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049e5:	89 44 24 08          	mov    %eax,0x8(%esp)
801049e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801049f0:	e8 bb fb ff ff       	call   801045b0 <argptr>
801049f5:	85 c0                	test   %eax,%eax
801049f7:	78 1f                	js     80104a18 <sys_write+0x68>
  return filewrite(f, p, n);
801049f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049fc:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a03:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a0a:	89 04 24             	mov    %eax,(%esp)
80104a0d:	e8 fe c5 ff ff       	call   80101010 <filewrite>
}
80104a12:	c9                   	leave  
80104a13:	c3                   	ret    
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a1d:	c9                   	leave  
80104a1e:	c3                   	ret    
80104a1f:	90                   	nop

80104a20 <sys_close>:
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104a26:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a29:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a2c:	e8 5f fe ff ff       	call   80104890 <argfd.constprop.0>
80104a31:	85 c0                	test   %eax,%eax
80104a33:	78 23                	js     80104a58 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104a35:	e8 a6 ec ff ff       	call   801036e0 <myproc>
80104a3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a3d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104a44:	00 
  fileclose(f);
80104a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a48:	89 04 24             	mov    %eax,(%esp)
80104a4b:	e8 10 c4 ff ff       	call   80100e60 <fileclose>
  return 0;
80104a50:	31 c0                	xor    %eax,%eax
}
80104a52:	c9                   	leave  
80104a53:	c3                   	ret    
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a5d:	c9                   	leave  
80104a5e:	c3                   	ret    
80104a5f:	90                   	nop

80104a60 <sys_fstat>:
{
80104a60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a61:	31 c0                	xor    %eax,%eax
{
80104a63:	89 e5                	mov    %esp,%ebp
80104a65:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a68:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104a6b:	e8 20 fe ff ff       	call   80104890 <argfd.constprop.0>
80104a70:	85 c0                	test   %eax,%eax
80104a72:	78 34                	js     80104aa8 <sys_fstat+0x48>
80104a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a77:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a7e:	00 
80104a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a8a:	e8 21 fb ff ff       	call   801045b0 <argptr>
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	78 15                	js     80104aa8 <sys_fstat+0x48>
  return filestat(f, st);
80104a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a96:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a9d:	89 04 24             	mov    %eax,(%esp)
80104aa0:	e8 7b c4 ff ff       	call   80100f20 <filestat>
}
80104aa5:	c9                   	leave  
80104aa6:	c3                   	ret    
80104aa7:	90                   	nop
    return -1;
80104aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104aad:	c9                   	leave  
80104aae:	c3                   	ret    
80104aaf:	90                   	nop

80104ab0 <sys_link>:
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	56                   	push   %esi
80104ab5:	53                   	push   %ebx
80104ab6:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ab9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104abc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ac0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ac7:	e8 34 fb ff ff       	call   80104600 <argstr>
80104acc:	85 c0                	test   %eax,%eax
80104ace:	0f 88 e6 00 00 00    	js     80104bba <sys_link+0x10a>
80104ad4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104adb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ae2:	e8 19 fb ff ff       	call   80104600 <argstr>
80104ae7:	85 c0                	test   %eax,%eax
80104ae9:	0f 88 cb 00 00 00    	js     80104bba <sys_link+0x10a>
  begin_op();
80104aef:	e8 5c e0 ff ff       	call   80102b50 <begin_op>
  if((ip = namei(old)) == 0){
80104af4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104af7:	89 04 24             	mov    %eax,(%esp)
80104afa:	e8 41 d4 ff ff       	call   80101f40 <namei>
80104aff:	85 c0                	test   %eax,%eax
80104b01:	89 c3                	mov    %eax,%ebx
80104b03:	0f 84 ac 00 00 00    	je     80104bb5 <sys_link+0x105>
  ilock(ip);
80104b09:	89 04 24             	mov    %eax,(%esp)
80104b0c:	e8 df cb ff ff       	call   801016f0 <ilock>
  if(ip->type == T_DIR){
80104b11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b16:	0f 84 91 00 00 00    	je     80104bad <sys_link+0xfd>
  ip->nlink++;
80104b1c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104b21:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104b24:	89 1c 24             	mov    %ebx,(%esp)
80104b27:	e8 04 cb ff ff       	call   80101630 <iupdate>
  iunlock(ip);
80104b2c:	89 1c 24             	mov    %ebx,(%esp)
80104b2f:	e8 9c cc ff ff       	call   801017d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104b34:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104b37:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b3b:	89 04 24             	mov    %eax,(%esp)
80104b3e:	e8 1d d4 ff ff       	call   80101f60 <nameiparent>
80104b43:	85 c0                	test   %eax,%eax
80104b45:	89 c6                	mov    %eax,%esi
80104b47:	74 4f                	je     80104b98 <sys_link+0xe8>
  ilock(dp);
80104b49:	89 04 24             	mov    %eax,(%esp)
80104b4c:	e8 9f cb ff ff       	call   801016f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104b51:	8b 03                	mov    (%ebx),%eax
80104b53:	39 06                	cmp    %eax,(%esi)
80104b55:	75 39                	jne    80104b90 <sys_link+0xe0>
80104b57:	8b 43 04             	mov    0x4(%ebx),%eax
80104b5a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b5e:	89 34 24             	mov    %esi,(%esp)
80104b61:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b65:	e8 f6 d2 ff ff       	call   80101e60 <dirlink>
80104b6a:	85 c0                	test   %eax,%eax
80104b6c:	78 22                	js     80104b90 <sys_link+0xe0>
  iunlockput(dp);
80104b6e:	89 34 24             	mov    %esi,(%esp)
80104b71:	e8 da cd ff ff       	call   80101950 <iunlockput>
  iput(ip);
80104b76:	89 1c 24             	mov    %ebx,(%esp)
80104b79:	e8 92 cc ff ff       	call   80101810 <iput>
  end_op();
80104b7e:	e8 3d e0 ff ff       	call   80102bc0 <end_op>
}
80104b83:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104b86:	31 c0                	xor    %eax,%eax
}
80104b88:	5b                   	pop    %ebx
80104b89:	5e                   	pop    %esi
80104b8a:	5f                   	pop    %edi
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret    
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104b90:	89 34 24             	mov    %esi,(%esp)
80104b93:	e8 b8 cd ff ff       	call   80101950 <iunlockput>
  ilock(ip);
80104b98:	89 1c 24             	mov    %ebx,(%esp)
80104b9b:	e8 50 cb ff ff       	call   801016f0 <ilock>
  ip->nlink--;
80104ba0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ba5:	89 1c 24             	mov    %ebx,(%esp)
80104ba8:	e8 83 ca ff ff       	call   80101630 <iupdate>
  iunlockput(ip);
80104bad:	89 1c 24             	mov    %ebx,(%esp)
80104bb0:	e8 9b cd ff ff       	call   80101950 <iunlockput>
  end_op();
80104bb5:	e8 06 e0 ff ff       	call   80102bc0 <end_op>
}
80104bba:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104bbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bc2:	5b                   	pop    %ebx
80104bc3:	5e                   	pop    %esi
80104bc4:	5f                   	pop    %edi
80104bc5:	5d                   	pop    %ebp
80104bc6:	c3                   	ret    
80104bc7:	89 f6                	mov    %esi,%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bd0 <sys_unlink>:
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
80104bd5:	53                   	push   %ebx
80104bd6:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104bd9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104be0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104be7:	e8 14 fa ff ff       	call   80104600 <argstr>
80104bec:	85 c0                	test   %eax,%eax
80104bee:	0f 88 76 01 00 00    	js     80104d6a <sys_unlink+0x19a>
  begin_op();
80104bf4:	e8 57 df ff ff       	call   80102b50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104bf9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104bfc:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104bff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c03:	89 04 24             	mov    %eax,(%esp)
80104c06:	e8 55 d3 ff ff       	call   80101f60 <nameiparent>
80104c0b:	85 c0                	test   %eax,%eax
80104c0d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104c10:	0f 84 4f 01 00 00    	je     80104d65 <sys_unlink+0x195>
  ilock(dp);
80104c16:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104c19:	89 34 24             	mov    %esi,(%esp)
80104c1c:	e8 cf ca ff ff       	call   801016f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104c21:	c7 44 24 04 7c 75 10 	movl   $0x8010757c,0x4(%esp)
80104c28:	80 
80104c29:	89 1c 24             	mov    %ebx,(%esp)
80104c2c:	e8 9f cf ff ff       	call   80101bd0 <namecmp>
80104c31:	85 c0                	test   %eax,%eax
80104c33:	0f 84 21 01 00 00    	je     80104d5a <sys_unlink+0x18a>
80104c39:	c7 44 24 04 7b 75 10 	movl   $0x8010757b,0x4(%esp)
80104c40:	80 
80104c41:	89 1c 24             	mov    %ebx,(%esp)
80104c44:	e8 87 cf ff ff       	call   80101bd0 <namecmp>
80104c49:	85 c0                	test   %eax,%eax
80104c4b:	0f 84 09 01 00 00    	je     80104d5a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104c51:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104c54:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c58:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c5c:	89 34 24             	mov    %esi,(%esp)
80104c5f:	e8 9c cf ff ff       	call   80101c00 <dirlookup>
80104c64:	85 c0                	test   %eax,%eax
80104c66:	89 c3                	mov    %eax,%ebx
80104c68:	0f 84 ec 00 00 00    	je     80104d5a <sys_unlink+0x18a>
  ilock(ip);
80104c6e:	89 04 24             	mov    %eax,(%esp)
80104c71:	e8 7a ca ff ff       	call   801016f0 <ilock>
  if(ip->nlink < 1)
80104c76:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c7b:	0f 8e 24 01 00 00    	jle    80104da5 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104c81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c86:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104c89:	74 7d                	je     80104d08 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104c8b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104c92:	00 
80104c93:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c9a:	00 
80104c9b:	89 34 24             	mov    %esi,(%esp)
80104c9e:	e8 1d f6 ff ff       	call   801042c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ca3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104ca6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104cad:	00 
80104cae:	89 74 24 04          	mov    %esi,0x4(%esp)
80104cb2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cb6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cb9:	89 04 24             	mov    %eax,(%esp)
80104cbc:	e8 df cd ff ff       	call   80101aa0 <writei>
80104cc1:	83 f8 10             	cmp    $0x10,%eax
80104cc4:	0f 85 cf 00 00 00    	jne    80104d99 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104cca:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ccf:	0f 84 a3 00 00 00    	je     80104d78 <sys_unlink+0x1a8>
  iunlockput(dp);
80104cd5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cd8:	89 04 24             	mov    %eax,(%esp)
80104cdb:	e8 70 cc ff ff       	call   80101950 <iunlockput>
  ip->nlink--;
80104ce0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ce5:	89 1c 24             	mov    %ebx,(%esp)
80104ce8:	e8 43 c9 ff ff       	call   80101630 <iupdate>
  iunlockput(ip);
80104ced:	89 1c 24             	mov    %ebx,(%esp)
80104cf0:	e8 5b cc ff ff       	call   80101950 <iunlockput>
  end_op();
80104cf5:	e8 c6 de ff ff       	call   80102bc0 <end_op>
}
80104cfa:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104cfd:	31 c0                	xor    %eax,%eax
}
80104cff:	5b                   	pop    %ebx
80104d00:	5e                   	pop    %esi
80104d01:	5f                   	pop    %edi
80104d02:	5d                   	pop    %ebp
80104d03:	c3                   	ret    
80104d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104d08:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104d0c:	0f 86 79 ff ff ff    	jbe    80104c8b <sys_unlink+0xbb>
80104d12:	bf 20 00 00 00       	mov    $0x20,%edi
80104d17:	eb 15                	jmp    80104d2e <sys_unlink+0x15e>
80104d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d20:	8d 57 10             	lea    0x10(%edi),%edx
80104d23:	3b 53 58             	cmp    0x58(%ebx),%edx
80104d26:	0f 83 5f ff ff ff    	jae    80104c8b <sys_unlink+0xbb>
80104d2c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d2e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d35:	00 
80104d36:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104d3a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104d3e:	89 1c 24             	mov    %ebx,(%esp)
80104d41:	e8 5a cc ff ff       	call   801019a0 <readi>
80104d46:	83 f8 10             	cmp    $0x10,%eax
80104d49:	75 42                	jne    80104d8d <sys_unlink+0x1bd>
    if(de.inum != 0)
80104d4b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104d50:	74 ce                	je     80104d20 <sys_unlink+0x150>
    iunlockput(ip);
80104d52:	89 1c 24             	mov    %ebx,(%esp)
80104d55:	e8 f6 cb ff ff       	call   80101950 <iunlockput>
  iunlockput(dp);
80104d5a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d5d:	89 04 24             	mov    %eax,(%esp)
80104d60:	e8 eb cb ff ff       	call   80101950 <iunlockput>
  end_op();
80104d65:	e8 56 de ff ff       	call   80102bc0 <end_op>
}
80104d6a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104d6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d72:	5b                   	pop    %ebx
80104d73:	5e                   	pop    %esi
80104d74:	5f                   	pop    %edi
80104d75:	5d                   	pop    %ebp
80104d76:	c3                   	ret    
80104d77:	90                   	nop
    dp->nlink--;
80104d78:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d7b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104d80:	89 04 24             	mov    %eax,(%esp)
80104d83:	e8 a8 c8 ff ff       	call   80101630 <iupdate>
80104d88:	e9 48 ff ff ff       	jmp    80104cd5 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104d8d:	c7 04 24 a0 75 10 80 	movl   $0x801075a0,(%esp)
80104d94:	e8 c7 b5 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104d99:	c7 04 24 b2 75 10 80 	movl   $0x801075b2,(%esp)
80104da0:	e8 bb b5 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104da5:	c7 04 24 8e 75 10 80 	movl   $0x8010758e,(%esp)
80104dac:	e8 af b5 ff ff       	call   80100360 <panic>
80104db1:	eb 0d                	jmp    80104dc0 <sys_open>
80104db3:	90                   	nop
80104db4:	90                   	nop
80104db5:	90                   	nop
80104db6:	90                   	nop
80104db7:	90                   	nop
80104db8:	90                   	nop
80104db9:	90                   	nop
80104dba:	90                   	nop
80104dbb:	90                   	nop
80104dbc:	90                   	nop
80104dbd:	90                   	nop
80104dbe:	90                   	nop
80104dbf:	90                   	nop

80104dc0 <sys_open>:

int
sys_open(void)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	57                   	push   %edi
80104dc4:	56                   	push   %esi
80104dc5:	53                   	push   %ebx
80104dc6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104dc9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104dcc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104dd7:	e8 24 f8 ff ff       	call   80104600 <argstr>
80104ddc:	85 c0                	test   %eax,%eax
80104dde:	0f 88 d1 00 00 00    	js     80104eb5 <sys_open+0xf5>
80104de4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104de7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104deb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104df2:	e8 79 f7 ff ff       	call   80104570 <argint>
80104df7:	85 c0                	test   %eax,%eax
80104df9:	0f 88 b6 00 00 00    	js     80104eb5 <sys_open+0xf5>
    return -1;

  begin_op();
80104dff:	e8 4c dd ff ff       	call   80102b50 <begin_op>

  if(omode & O_CREATE){
80104e04:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104e08:	0f 85 82 00 00 00    	jne    80104e90 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104e0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e11:	89 04 24             	mov    %eax,(%esp)
80104e14:	e8 27 d1 ff ff       	call   80101f40 <namei>
80104e19:	85 c0                	test   %eax,%eax
80104e1b:	89 c6                	mov    %eax,%esi
80104e1d:	0f 84 8d 00 00 00    	je     80104eb0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104e23:	89 04 24             	mov    %eax,(%esp)
80104e26:	e8 c5 c8 ff ff       	call   801016f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e2b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104e30:	0f 84 92 00 00 00    	je     80104ec8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104e36:	e8 65 bf ff ff       	call   80100da0 <filealloc>
80104e3b:	85 c0                	test   %eax,%eax
80104e3d:	89 c3                	mov    %eax,%ebx
80104e3f:	0f 84 93 00 00 00    	je     80104ed8 <sys_open+0x118>
80104e45:	e8 86 f8 ff ff       	call   801046d0 <fdalloc>
80104e4a:	85 c0                	test   %eax,%eax
80104e4c:	89 c7                	mov    %eax,%edi
80104e4e:	0f 88 94 00 00 00    	js     80104ee8 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104e54:	89 34 24             	mov    %esi,(%esp)
80104e57:	e8 74 c9 ff ff       	call   801017d0 <iunlock>
  end_op();
80104e5c:	e8 5f dd ff ff       	call   80102bc0 <end_op>

  f->type = FD_INODE;
80104e61:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
80104e6a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104e6d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104e74:	89 c2                	mov    %eax,%edx
80104e76:	83 e2 01             	and    $0x1,%edx
80104e79:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e7c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
80104e7e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80104e81:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e83:	0f 95 43 09          	setne  0x9(%ebx)
}
80104e87:	83 c4 2c             	add    $0x2c,%esp
80104e8a:	5b                   	pop    %ebx
80104e8b:	5e                   	pop    %esi
80104e8c:	5f                   	pop    %edi
80104e8d:	5d                   	pop    %ebp
80104e8e:	c3                   	ret    
80104e8f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80104e90:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e93:	31 c9                	xor    %ecx,%ecx
80104e95:	ba 02 00 00 00       	mov    $0x2,%edx
80104e9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ea1:	e8 6a f8 ff ff       	call   80104710 <create>
    if(ip == 0){
80104ea6:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80104ea8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104eaa:	75 8a                	jne    80104e36 <sys_open+0x76>
80104eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80104eb0:	e8 0b dd ff ff       	call   80102bc0 <end_op>
}
80104eb5:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80104eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ebd:	5b                   	pop    %ebx
80104ebe:	5e                   	pop    %esi
80104ebf:	5f                   	pop    %edi
80104ec0:	5d                   	pop    %ebp
80104ec1:	c3                   	ret    
80104ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ec8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104ecb:	85 c0                	test   %eax,%eax
80104ecd:	0f 84 63 ff ff ff    	je     80104e36 <sys_open+0x76>
80104ed3:	90                   	nop
80104ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104ed8:	89 34 24             	mov    %esi,(%esp)
80104edb:	e8 70 ca ff ff       	call   80101950 <iunlockput>
80104ee0:	eb ce                	jmp    80104eb0 <sys_open+0xf0>
80104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80104ee8:	89 1c 24             	mov    %ebx,(%esp)
80104eeb:	e8 70 bf ff ff       	call   80100e60 <fileclose>
80104ef0:	eb e6                	jmp    80104ed8 <sys_open+0x118>
80104ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f00 <sys_mkdir>:

int
sys_mkdir(void)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104f06:	e8 45 dc ff ff       	call   80102b50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104f0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f19:	e8 e2 f6 ff ff       	call   80104600 <argstr>
80104f1e:	85 c0                	test   %eax,%eax
80104f20:	78 2e                	js     80104f50 <sys_mkdir+0x50>
80104f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f25:	31 c9                	xor    %ecx,%ecx
80104f27:	ba 01 00 00 00       	mov    $0x1,%edx
80104f2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f33:	e8 d8 f7 ff ff       	call   80104710 <create>
80104f38:	85 c0                	test   %eax,%eax
80104f3a:	74 14                	je     80104f50 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f3c:	89 04 24             	mov    %eax,(%esp)
80104f3f:	e8 0c ca ff ff       	call   80101950 <iunlockput>
  end_op();
80104f44:	e8 77 dc ff ff       	call   80102bc0 <end_op>
  return 0;
80104f49:	31 c0                	xor    %eax,%eax
}
80104f4b:	c9                   	leave  
80104f4c:	c3                   	ret    
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104f50:	e8 6b dc ff ff       	call   80102bc0 <end_op>
    return -1;
80104f55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f5a:	c9                   	leave  
80104f5b:	c3                   	ret    
80104f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f60 <sys_mknod>:

int
sys_mknod(void)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104f66:	e8 e5 db ff ff       	call   80102b50 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104f6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f6e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f79:	e8 82 f6 ff ff       	call   80104600 <argstr>
80104f7e:	85 c0                	test   %eax,%eax
80104f80:	78 5e                	js     80104fe0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104f82:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f85:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f90:	e8 db f5 ff ff       	call   80104570 <argint>
  if((argstr(0, &path)) < 0 ||
80104f95:	85 c0                	test   %eax,%eax
80104f97:	78 47                	js     80104fe0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104f99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fa0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104fa7:	e8 c4 f5 ff ff       	call   80104570 <argint>
     argint(1, &major) < 0 ||
80104fac:	85 c0                	test   %eax,%eax
80104fae:	78 30                	js     80104fe0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104fb0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80104fb4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80104fb9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104fbd:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80104fc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fc3:	e8 48 f7 ff ff       	call   80104710 <create>
80104fc8:	85 c0                	test   %eax,%eax
80104fca:	74 14                	je     80104fe0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104fcc:	89 04 24             	mov    %eax,(%esp)
80104fcf:	e8 7c c9 ff ff       	call   80101950 <iunlockput>
  end_op();
80104fd4:	e8 e7 db ff ff       	call   80102bc0 <end_op>
  return 0;
80104fd9:	31 c0                	xor    %eax,%eax
}
80104fdb:	c9                   	leave  
80104fdc:	c3                   	ret    
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104fe0:	e8 db db ff ff       	call   80102bc0 <end_op>
    return -1;
80104fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fea:	c9                   	leave  
80104feb:	c3                   	ret    
80104fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ff0 <sys_chdir>:

int
sys_chdir(void)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
80104ff5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104ff8:	e8 e3 e6 ff ff       	call   801036e0 <myproc>
80104ffd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104fff:	e8 4c db ff ff       	call   80102b50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105004:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105007:	89 44 24 04          	mov    %eax,0x4(%esp)
8010500b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105012:	e8 e9 f5 ff ff       	call   80104600 <argstr>
80105017:	85 c0                	test   %eax,%eax
80105019:	78 4a                	js     80105065 <sys_chdir+0x75>
8010501b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010501e:	89 04 24             	mov    %eax,(%esp)
80105021:	e8 1a cf ff ff       	call   80101f40 <namei>
80105026:	85 c0                	test   %eax,%eax
80105028:	89 c3                	mov    %eax,%ebx
8010502a:	74 39                	je     80105065 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010502c:	89 04 24             	mov    %eax,(%esp)
8010502f:	e8 bc c6 ff ff       	call   801016f0 <ilock>
  if(ip->type != T_DIR){
80105034:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105039:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010503c:	75 22                	jne    80105060 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010503e:	e8 8d c7 ff ff       	call   801017d0 <iunlock>
  iput(curproc->cwd);
80105043:	8b 46 68             	mov    0x68(%esi),%eax
80105046:	89 04 24             	mov    %eax,(%esp)
80105049:	e8 c2 c7 ff ff       	call   80101810 <iput>
  end_op();
8010504e:	e8 6d db ff ff       	call   80102bc0 <end_op>
  curproc->cwd = ip;
  return 0;
80105053:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105055:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105058:	83 c4 20             	add    $0x20,%esp
8010505b:	5b                   	pop    %ebx
8010505c:	5e                   	pop    %esi
8010505d:	5d                   	pop    %ebp
8010505e:	c3                   	ret    
8010505f:	90                   	nop
    iunlockput(ip);
80105060:	e8 eb c8 ff ff       	call   80101950 <iunlockput>
    end_op();
80105065:	e8 56 db ff ff       	call   80102bc0 <end_op>
}
8010506a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010506d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105072:	5b                   	pop    %ebx
80105073:	5e                   	pop    %esi
80105074:	5d                   	pop    %ebp
80105075:	c3                   	ret    
80105076:	8d 76 00             	lea    0x0(%esi),%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <sys_exec>:

int
sys_exec(void)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	56                   	push   %esi
80105085:	53                   	push   %ebx
80105086:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010508c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105092:	89 44 24 04          	mov    %eax,0x4(%esp)
80105096:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010509d:	e8 5e f5 ff ff       	call   80104600 <argstr>
801050a2:	85 c0                	test   %eax,%eax
801050a4:	0f 88 84 00 00 00    	js     8010512e <sys_exec+0xae>
801050aa:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801050b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801050b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050bb:	e8 b0 f4 ff ff       	call   80104570 <argint>
801050c0:	85 c0                	test   %eax,%eax
801050c2:	78 6a                	js     8010512e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801050c4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801050ca:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801050cc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801050d3:	00 
801050d4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801050da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801050e1:	00 
801050e2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801050e8:	89 04 24             	mov    %eax,(%esp)
801050eb:	e8 d0 f1 ff ff       	call   801042c0 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801050f0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801050f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801050fa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801050fd:	89 04 24             	mov    %eax,(%esp)
80105100:	e8 0b f4 ff ff       	call   80104510 <fetchint>
80105105:	85 c0                	test   %eax,%eax
80105107:	78 25                	js     8010512e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105109:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010510f:	85 c0                	test   %eax,%eax
80105111:	74 2d                	je     80105140 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105113:	89 74 24 04          	mov    %esi,0x4(%esp)
80105117:	89 04 24             	mov    %eax,(%esp)
8010511a:	e8 11 f4 ff ff       	call   80104530 <fetchstr>
8010511f:	85 c0                	test   %eax,%eax
80105121:	78 0b                	js     8010512e <sys_exec+0xae>
  for(i=0;; i++){
80105123:	83 c3 01             	add    $0x1,%ebx
80105126:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105129:	83 fb 20             	cmp    $0x20,%ebx
8010512c:	75 c2                	jne    801050f0 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
8010512e:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
80105134:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105139:	5b                   	pop    %ebx
8010513a:	5e                   	pop    %esi
8010513b:	5f                   	pop    %edi
8010513c:	5d                   	pop    %ebp
8010513d:	c3                   	ret    
8010513e:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
80105140:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105146:	89 44 24 04          	mov    %eax,0x4(%esp)
8010514a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105150:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105157:	00 00 00 00 
  return exec(path, argv);
8010515b:	89 04 24             	mov    %eax,(%esp)
8010515e:	e8 3d b8 ff ff       	call   801009a0 <exec>
}
80105163:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105169:	5b                   	pop    %ebx
8010516a:	5e                   	pop    %esi
8010516b:	5f                   	pop    %edi
8010516c:	5d                   	pop    %ebp
8010516d:	c3                   	ret    
8010516e:	66 90                	xchg   %ax,%ax

80105170 <sys_pipe>:

int
sys_pipe(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	53                   	push   %ebx
80105174:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105177:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010517a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105181:	00 
80105182:	89 44 24 04          	mov    %eax,0x4(%esp)
80105186:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010518d:	e8 1e f4 ff ff       	call   801045b0 <argptr>
80105192:	85 c0                	test   %eax,%eax
80105194:	78 6d                	js     80105203 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105196:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105199:	89 44 24 04          	mov    %eax,0x4(%esp)
8010519d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051a0:	89 04 24             	mov    %eax,(%esp)
801051a3:	e8 08 e0 ff ff       	call   801031b0 <pipealloc>
801051a8:	85 c0                	test   %eax,%eax
801051aa:	78 57                	js     80105203 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801051ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051af:	e8 1c f5 ff ff       	call   801046d0 <fdalloc>
801051b4:	85 c0                	test   %eax,%eax
801051b6:	89 c3                	mov    %eax,%ebx
801051b8:	78 33                	js     801051ed <sys_pipe+0x7d>
801051ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051bd:	e8 0e f5 ff ff       	call   801046d0 <fdalloc>
801051c2:	85 c0                	test   %eax,%eax
801051c4:	78 1a                	js     801051e0 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801051c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051c9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801051cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051ce:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
801051d1:	83 c4 24             	add    $0x24,%esp
  return 0;
801051d4:	31 c0                	xor    %eax,%eax
}
801051d6:	5b                   	pop    %ebx
801051d7:	5d                   	pop    %ebp
801051d8:	c3                   	ret    
801051d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801051e0:	e8 fb e4 ff ff       	call   801036e0 <myproc>
801051e5:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
801051ec:	00 
    fileclose(rf);
801051ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051f0:	89 04 24             	mov    %eax,(%esp)
801051f3:	e8 68 bc ff ff       	call   80100e60 <fileclose>
    fileclose(wf);
801051f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051fb:	89 04 24             	mov    %eax,(%esp)
801051fe:	e8 5d bc ff ff       	call   80100e60 <fileclose>
}
80105203:	83 c4 24             	add    $0x24,%esp
    return -1;
80105206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010520b:	5b                   	pop    %ebx
8010520c:	5d                   	pop    %ebp
8010520d:	c3                   	ret    
8010520e:	66 90                	xchg   %ax,%ax

80105210 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
80105216:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105219:	89 44 24 04          	mov    %eax,0x4(%esp)
8010521d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105224:	e8 47 f3 ff ff       	call   80104570 <argint>
80105229:	85 c0                	test   %eax,%eax
8010522b:	78 33                	js     80105260 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
8010522d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105230:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105237:	00 
80105238:	89 44 24 04          	mov    %eax,0x4(%esp)
8010523c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105243:	e8 68 f3 ff ff       	call   801045b0 <argptr>
80105248:	85 c0                	test   %eax,%eax
8010524a:	78 14                	js     80105260 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
8010524c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010524f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105253:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105256:	89 04 24             	mov    %eax,(%esp)
80105259:	e8 82 1b 00 00       	call   80106de0 <shm_open>
}
8010525e:	c9                   	leave  
8010525f:	c3                   	ret    
    return -1;
80105260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105265:	c9                   	leave  
80105266:	c3                   	ret    
80105267:	89 f6                	mov    %esi,%esi
80105269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105270 <sys_shm_close>:

int sys_shm_close(void) {
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
80105276:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105279:	89 44 24 04          	mov    %eax,0x4(%esp)
8010527d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105284:	e8 e7 f2 ff ff       	call   80104570 <argint>
80105289:	85 c0                	test   %eax,%eax
8010528b:	78 13                	js     801052a0 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
8010528d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105290:	89 04 24             	mov    %eax,(%esp)
80105293:	e8 58 1b 00 00       	call   80106df0 <shm_close>
}
80105298:	c9                   	leave  
80105299:	c3                   	ret    
8010529a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <sys_fork>:

int
sys_fork(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801052b3:	5d                   	pop    %ebp
  return fork();
801052b4:	e9 d7 e5 ff ff       	jmp    80103890 <fork>
801052b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_exit>:

int
sys_exit(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801052c6:	e8 15 e8 ff ff       	call   80103ae0 <exit>
  return 0;  // not reached
}
801052cb:	31 c0                	xor    %eax,%eax
801052cd:	c9                   	leave  
801052ce:	c3                   	ret    
801052cf:	90                   	nop

801052d0 <sys_wait>:

int
sys_wait(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801052d3:	5d                   	pop    %ebp
  return wait();
801052d4:	e9 17 ea ff ff       	jmp    80103cf0 <wait>
801052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052e0 <sys_kill>:

int
sys_kill(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801052e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052f4:	e8 77 f2 ff ff       	call   80104570 <argint>
801052f9:	85 c0                	test   %eax,%eax
801052fb:	78 13                	js     80105310 <sys_kill+0x30>
    return -1;
  return kill(pid);
801052fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105300:	89 04 24             	mov    %eax,(%esp)
80105303:	e8 28 eb ff ff       	call   80103e30 <kill>
}
80105308:	c9                   	leave  
80105309:	c3                   	ret    
8010530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105315:	c9                   	leave  
80105316:	c3                   	ret    
80105317:	89 f6                	mov    %esi,%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105320 <sys_getpid>:

int
sys_getpid(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105326:	e8 b5 e3 ff ff       	call   801036e0 <myproc>
8010532b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010532e:	c9                   	leave  
8010532f:	c3                   	ret    

80105330 <sys_sbrk>:

int
sys_sbrk(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	53                   	push   %ebx
80105334:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105337:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010533a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010533e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105345:	e8 26 f2 ff ff       	call   80104570 <argint>
8010534a:	85 c0                	test   %eax,%eax
8010534c:	78 22                	js     80105370 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010534e:	e8 8d e3 ff ff       	call   801036e0 <myproc>
  if(growproc(n) < 0)
80105353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
80105356:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105358:	89 14 24             	mov    %edx,(%esp)
8010535b:	e8 c0 e4 ff ff       	call   80103820 <growproc>
80105360:	85 c0                	test   %eax,%eax
80105362:	78 0c                	js     80105370 <sys_sbrk+0x40>
    return -1;
  return addr;
80105364:	89 d8                	mov    %ebx,%eax
}
80105366:	83 c4 24             	add    $0x24,%esp
80105369:	5b                   	pop    %ebx
8010536a:	5d                   	pop    %ebp
8010536b:	c3                   	ret    
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105375:	eb ef                	jmp    80105366 <sys_sbrk+0x36>
80105377:	89 f6                	mov    %esi,%esi
80105379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105380 <sys_sleep>:

int
sys_sleep(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	53                   	push   %ebx
80105384:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105387:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010538a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010538e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105395:	e8 d6 f1 ff ff       	call   80104570 <argint>
8010539a:	85 c0                	test   %eax,%eax
8010539c:	78 7e                	js     8010541c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010539e:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053a5:	e8 d6 ed ff ff       	call   80104180 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801053aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801053ad:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
801053b3:	85 d2                	test   %edx,%edx
801053b5:	75 29                	jne    801053e0 <sys_sleep+0x60>
801053b7:	eb 4f                	jmp    80105408 <sys_sleep+0x88>
801053b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801053c0:	c7 44 24 04 60 4d 11 	movl   $0x80114d60,0x4(%esp)
801053c7:	80 
801053c8:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
801053cf:	e8 6c e8 ff ff       	call   80103c40 <sleep>
  while(ticks - ticks0 < n){
801053d4:	a1 a0 55 11 80       	mov    0x801155a0,%eax
801053d9:	29 d8                	sub    %ebx,%eax
801053db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801053de:	73 28                	jae    80105408 <sys_sleep+0x88>
    if(myproc()->killed){
801053e0:	e8 fb e2 ff ff       	call   801036e0 <myproc>
801053e5:	8b 40 24             	mov    0x24(%eax),%eax
801053e8:	85 c0                	test   %eax,%eax
801053ea:	74 d4                	je     801053c0 <sys_sleep+0x40>
      release(&tickslock);
801053ec:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053f3:	e8 78 ee ff ff       	call   80104270 <release>
      return -1;
801053f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801053fd:	83 c4 24             	add    $0x24,%esp
80105400:	5b                   	pop    %ebx
80105401:	5d                   	pop    %ebp
80105402:	c3                   	ret    
80105403:	90                   	nop
80105404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105408:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010540f:	e8 5c ee ff ff       	call   80104270 <release>
}
80105414:	83 c4 24             	add    $0x24,%esp
  return 0;
80105417:	31 c0                	xor    %eax,%eax
}
80105419:	5b                   	pop    %ebx
8010541a:	5d                   	pop    %ebp
8010541b:	c3                   	ret    
    return -1;
8010541c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105421:	eb da                	jmp    801053fd <sys_sleep+0x7d>
80105423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105430 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	53                   	push   %ebx
80105434:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105437:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010543e:	e8 3d ed ff ff       	call   80104180 <acquire>
  xticks = ticks;
80105443:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
80105449:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105450:	e8 1b ee ff ff       	call   80104270 <release>
  return xticks;
}
80105455:	83 c4 14             	add    $0x14,%esp
80105458:	89 d8                	mov    %ebx,%eax
8010545a:	5b                   	pop    %ebx
8010545b:	5d                   	pop    %ebp
8010545c:	c3                   	ret    

8010545d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010545d:	1e                   	push   %ds
  pushl %es
8010545e:	06                   	push   %es
  pushl %fs
8010545f:	0f a0                	push   %fs
  pushl %gs
80105461:	0f a8                	push   %gs
  pushal
80105463:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105464:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105468:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010546a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010546c:	54                   	push   %esp
  call trap
8010546d:	e8 de 00 00 00       	call   80105550 <trap>
  addl $4, %esp
80105472:	83 c4 04             	add    $0x4,%esp

80105475 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105475:	61                   	popa   
  popl %gs
80105476:	0f a9                	pop    %gs
  popl %fs
80105478:	0f a1                	pop    %fs
  popl %es
8010547a:	07                   	pop    %es
  popl %ds
8010547b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010547c:	83 c4 08             	add    $0x8,%esp
  iret
8010547f:	cf                   	iret   

80105480 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105480:	31 c0                	xor    %eax,%eax
80105482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105488:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010548f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105494:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
8010549b:	80 
8010549c:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
801054a3:	00 
801054a4:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
801054ab:	8e 
801054ac:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
801054b3:	80 
801054b4:	c1 ea 10             	shr    $0x10,%edx
801054b7:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
801054be:	80 
  for(i = 0; i < 256; i++)
801054bf:	83 c0 01             	add    $0x1,%eax
801054c2:	3d 00 01 00 00       	cmp    $0x100,%eax
801054c7:	75 bf                	jne    80105488 <tvinit+0x8>
{
801054c9:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054ca:	ba 08 00 00 00       	mov    $0x8,%edx
{
801054cf:	89 e5                	mov    %esp,%ebp
801054d1:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054d4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801054d9:	c7 44 24 04 c1 75 10 	movl   $0x801075c1,0x4(%esp)
801054e0:	80 
801054e1:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054e8:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
801054ef:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
801054f5:	c1 e8 10             	shr    $0x10,%eax
801054f8:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
801054ff:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
80105506:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
8010550c:	e8 7f eb ff ff       	call   80104090 <initlock>
}
80105511:	c9                   	leave  
80105512:	c3                   	ret    
80105513:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105520 <idtinit>:

void
idtinit(void)
{
80105520:	55                   	push   %ebp
  pd[0] = size-1;
80105521:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105526:	89 e5                	mov    %esp,%ebp
80105528:	83 ec 10             	sub    $0x10,%esp
8010552b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010552f:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105534:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105538:	c1 e8 10             	shr    $0x10,%eax
8010553b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010553f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105542:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105545:	c9                   	leave  
80105546:	c3                   	ret    
80105547:	89 f6                	mov    %esi,%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105550 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	57                   	push   %edi
80105554:	56                   	push   %esi
80105555:	53                   	push   %ebx
80105556:	83 ec 3c             	sub    $0x3c,%esp
80105559:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010555c:	8b 43 30             	mov    0x30(%ebx),%eax
8010555f:	83 f8 40             	cmp    $0x40,%eax
80105562:	0f 84 a0 01 00 00    	je     80105708 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105568:	83 e8 20             	sub    $0x20,%eax
8010556b:	83 f8 1f             	cmp    $0x1f,%eax
8010556e:	77 08                	ja     80105578 <trap+0x28>
80105570:	ff 24 85 68 76 10 80 	jmp    *-0x7fef8998(,%eax,4)
80105577:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105578:	e8 63 e1 ff ff       	call   801036e0 <myproc>
8010557d:	85 c0                	test   %eax,%eax
8010557f:	90                   	nop
80105580:	0f 84 fa 01 00 00    	je     80105780 <trap+0x230>
80105586:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010558a:	0f 84 f0 01 00 00    	je     80105780 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105590:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105593:	8b 53 38             	mov    0x38(%ebx),%edx
80105596:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105599:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010559c:	e8 1f e1 ff ff       	call   801036c0 <cpuid>
801055a1:	8b 73 30             	mov    0x30(%ebx),%esi
801055a4:	89 c7                	mov    %eax,%edi
801055a6:	8b 43 34             	mov    0x34(%ebx),%eax
801055a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801055ac:	e8 2f e1 ff ff       	call   801036e0 <myproc>
801055b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801055b4:	e8 27 e1 ff ff       	call   801036e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801055bc:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801055c0:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055c3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801055c6:	89 7c 24 14          	mov    %edi,0x14(%esp)
801055ca:	89 54 24 18          	mov    %edx,0x18(%esp)
801055ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
801055d1:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055d4:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801055d8:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055dc:	89 54 24 10          	mov    %edx,0x10(%esp)
801055e0:	8b 40 10             	mov    0x10(%eax),%eax
801055e3:	c7 04 24 24 76 10 80 	movl   $0x80107624,(%esp)
801055ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ee:	e8 5d b0 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801055f3:	e8 e8 e0 ff ff       	call   801036e0 <myproc>
801055f8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801055ff:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105600:	e8 db e0 ff ff       	call   801036e0 <myproc>
80105605:	85 c0                	test   %eax,%eax
80105607:	74 0c                	je     80105615 <trap+0xc5>
80105609:	e8 d2 e0 ff ff       	call   801036e0 <myproc>
8010560e:	8b 50 24             	mov    0x24(%eax),%edx
80105611:	85 d2                	test   %edx,%edx
80105613:	75 4b                	jne    80105660 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105615:	e8 c6 e0 ff ff       	call   801036e0 <myproc>
8010561a:	85 c0                	test   %eax,%eax
8010561c:	74 0d                	je     8010562b <trap+0xdb>
8010561e:	66 90                	xchg   %ax,%ax
80105620:	e8 bb e0 ff ff       	call   801036e0 <myproc>
80105625:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105629:	74 4d                	je     80105678 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010562b:	e8 b0 e0 ff ff       	call   801036e0 <myproc>
80105630:	85 c0                	test   %eax,%eax
80105632:	74 1d                	je     80105651 <trap+0x101>
80105634:	e8 a7 e0 ff ff       	call   801036e0 <myproc>
80105639:	8b 40 24             	mov    0x24(%eax),%eax
8010563c:	85 c0                	test   %eax,%eax
8010563e:	74 11                	je     80105651 <trap+0x101>
80105640:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105644:	83 e0 03             	and    $0x3,%eax
80105647:	66 83 f8 03          	cmp    $0x3,%ax
8010564b:	0f 84 e8 00 00 00    	je     80105739 <trap+0x1e9>
    exit();
}
80105651:	83 c4 3c             	add    $0x3c,%esp
80105654:	5b                   	pop    %ebx
80105655:	5e                   	pop    %esi
80105656:	5f                   	pop    %edi
80105657:	5d                   	pop    %ebp
80105658:	c3                   	ret    
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105660:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105664:	83 e0 03             	and    $0x3,%eax
80105667:	66 83 f8 03          	cmp    $0x3,%ax
8010566b:	75 a8                	jne    80105615 <trap+0xc5>
    exit();
8010566d:	e8 6e e4 ff ff       	call   80103ae0 <exit>
80105672:	eb a1                	jmp    80105615 <trap+0xc5>
80105674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105678:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105680:	75 a9                	jne    8010562b <trap+0xdb>
    yield();
80105682:	e8 79 e5 ff ff       	call   80103c00 <yield>
80105687:	eb a2                	jmp    8010562b <trap+0xdb>
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105690:	e8 2b e0 ff ff       	call   801036c0 <cpuid>
80105695:	85 c0                	test   %eax,%eax
80105697:	0f 84 b3 00 00 00    	je     80105750 <trap+0x200>
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
801056a0:	e8 1b d1 ff ff       	call   801027c0 <lapiceoi>
    break;
801056a5:	e9 56 ff ff ff       	jmp    80105600 <trap+0xb0>
801056aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
801056b0:	e8 5b cf ff ff       	call   80102610 <kbdintr>
    lapiceoi();
801056b5:	e8 06 d1 ff ff       	call   801027c0 <lapiceoi>
    break;
801056ba:	e9 41 ff ff ff       	jmp    80105600 <trap+0xb0>
801056bf:	90                   	nop
    uartintr();
801056c0:	e8 1b 02 00 00       	call   801058e0 <uartintr>
    lapiceoi();
801056c5:	e8 f6 d0 ff ff       	call   801027c0 <lapiceoi>
    break;
801056ca:	e9 31 ff ff ff       	jmp    80105600 <trap+0xb0>
801056cf:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801056d0:	8b 7b 38             	mov    0x38(%ebx),%edi
801056d3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801056d7:	e8 e4 df ff ff       	call   801036c0 <cpuid>
801056dc:	c7 04 24 cc 75 10 80 	movl   $0x801075cc,(%esp)
801056e3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801056e7:	89 74 24 08          	mov    %esi,0x8(%esp)
801056eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801056ef:	e8 5c af ff ff       	call   80100650 <cprintf>
    lapiceoi();
801056f4:	e8 c7 d0 ff ff       	call   801027c0 <lapiceoi>
    break;
801056f9:	e9 02 ff ff ff       	jmp    80105600 <trap+0xb0>
801056fe:	66 90                	xchg   %ax,%ax
    ideintr();
80105700:	e8 bb c9 ff ff       	call   801020c0 <ideintr>
80105705:	eb 96                	jmp    8010569d <trap+0x14d>
80105707:	90                   	nop
80105708:	90                   	nop
80105709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105710:	e8 cb df ff ff       	call   801036e0 <myproc>
80105715:	8b 70 24             	mov    0x24(%eax),%esi
80105718:	85 f6                	test   %esi,%esi
8010571a:	75 2c                	jne    80105748 <trap+0x1f8>
    myproc()->tf = tf;
8010571c:	e8 bf df ff ff       	call   801036e0 <myproc>
80105721:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105724:	e8 37 ef ff ff       	call   80104660 <syscall>
    if(myproc()->killed)
80105729:	e8 b2 df ff ff       	call   801036e0 <myproc>
8010572e:	8b 48 24             	mov    0x24(%eax),%ecx
80105731:	85 c9                	test   %ecx,%ecx
80105733:	0f 84 18 ff ff ff    	je     80105651 <trap+0x101>
}
80105739:	83 c4 3c             	add    $0x3c,%esp
8010573c:	5b                   	pop    %ebx
8010573d:	5e                   	pop    %esi
8010573e:	5f                   	pop    %edi
8010573f:	5d                   	pop    %ebp
      exit();
80105740:	e9 9b e3 ff ff       	jmp    80103ae0 <exit>
80105745:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105748:	e8 93 e3 ff ff       	call   80103ae0 <exit>
8010574d:	eb cd                	jmp    8010571c <trap+0x1cc>
8010574f:	90                   	nop
      acquire(&tickslock);
80105750:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105757:	e8 24 ea ff ff       	call   80104180 <acquire>
      wakeup(&ticks);
8010575c:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
80105763:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
8010576a:	e8 61 e6 ff ff       	call   80103dd0 <wakeup>
      release(&tickslock);
8010576f:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105776:	e8 f5 ea ff ff       	call   80104270 <release>
8010577b:	e9 1d ff ff ff       	jmp    8010569d <trap+0x14d>
80105780:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105783:	8b 73 38             	mov    0x38(%ebx),%esi
80105786:	e8 35 df ff ff       	call   801036c0 <cpuid>
8010578b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010578f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105793:	89 44 24 08          	mov    %eax,0x8(%esp)
80105797:	8b 43 30             	mov    0x30(%ebx),%eax
8010579a:	c7 04 24 f0 75 10 80 	movl   $0x801075f0,(%esp)
801057a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801057a5:	e8 a6 ae ff ff       	call   80100650 <cprintf>
      panic("trap");
801057aa:	c7 04 24 c6 75 10 80 	movl   $0x801075c6,(%esp)
801057b1:	e8 aa ab ff ff       	call   80100360 <panic>
801057b6:	66 90                	xchg   %ax,%ax
801057b8:	66 90                	xchg   %ax,%ax
801057ba:	66 90                	xchg   %ax,%ax
801057bc:	66 90                	xchg   %ax,%ax
801057be:	66 90                	xchg   %ax,%ax

801057c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801057c0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
801057c5:	55                   	push   %ebp
801057c6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801057c8:	85 c0                	test   %eax,%eax
801057ca:	74 14                	je     801057e0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801057cc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801057d1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801057d2:	a8 01                	test   $0x1,%al
801057d4:	74 0a                	je     801057e0 <uartgetc+0x20>
801057d6:	b2 f8                	mov    $0xf8,%dl
801057d8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801057d9:	0f b6 c0             	movzbl %al,%eax
}
801057dc:	5d                   	pop    %ebp
801057dd:	c3                   	ret    
801057de:	66 90                	xchg   %ax,%ax
    return -1;
801057e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057e5:	5d                   	pop    %ebp
801057e6:	c3                   	ret    
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <uartputc>:
  if(!uart)
801057f0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
801057f5:	85 c0                	test   %eax,%eax
801057f7:	74 3f                	je     80105838 <uartputc+0x48>
{
801057f9:	55                   	push   %ebp
801057fa:	89 e5                	mov    %esp,%ebp
801057fc:	56                   	push   %esi
801057fd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105802:	53                   	push   %ebx
  if(!uart)
80105803:	bb 80 00 00 00       	mov    $0x80,%ebx
{
80105808:	83 ec 10             	sub    $0x10,%esp
8010580b:	eb 14                	jmp    80105821 <uartputc+0x31>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105810:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105817:	e8 c4 cf ff ff       	call   801027e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010581c:	83 eb 01             	sub    $0x1,%ebx
8010581f:	74 07                	je     80105828 <uartputc+0x38>
80105821:	89 f2                	mov    %esi,%edx
80105823:	ec                   	in     (%dx),%al
80105824:	a8 20                	test   $0x20,%al
80105826:	74 e8                	je     80105810 <uartputc+0x20>
  outb(COM1+0, c);
80105828:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010582c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105831:	ee                   	out    %al,(%dx)
}
80105832:	83 c4 10             	add    $0x10,%esp
80105835:	5b                   	pop    %ebx
80105836:	5e                   	pop    %esi
80105837:	5d                   	pop    %ebp
80105838:	f3 c3                	repz ret 
8010583a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105840 <uartinit>:
{
80105840:	55                   	push   %ebp
80105841:	31 c9                	xor    %ecx,%ecx
80105843:	89 e5                	mov    %esp,%ebp
80105845:	89 c8                	mov    %ecx,%eax
80105847:	57                   	push   %edi
80105848:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010584d:	56                   	push   %esi
8010584e:	89 fa                	mov    %edi,%edx
80105850:	53                   	push   %ebx
80105851:	83 ec 1c             	sub    $0x1c,%esp
80105854:	ee                   	out    %al,(%dx)
80105855:	be fb 03 00 00       	mov    $0x3fb,%esi
8010585a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010585f:	89 f2                	mov    %esi,%edx
80105861:	ee                   	out    %al,(%dx)
80105862:	b8 0c 00 00 00       	mov    $0xc,%eax
80105867:	b2 f8                	mov    $0xf8,%dl
80105869:	ee                   	out    %al,(%dx)
8010586a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010586f:	89 c8                	mov    %ecx,%eax
80105871:	89 da                	mov    %ebx,%edx
80105873:	ee                   	out    %al,(%dx)
80105874:	b8 03 00 00 00       	mov    $0x3,%eax
80105879:	89 f2                	mov    %esi,%edx
8010587b:	ee                   	out    %al,(%dx)
8010587c:	b2 fc                	mov    $0xfc,%dl
8010587e:	89 c8                	mov    %ecx,%eax
80105880:	ee                   	out    %al,(%dx)
80105881:	b8 01 00 00 00       	mov    $0x1,%eax
80105886:	89 da                	mov    %ebx,%edx
80105888:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105889:	b2 fd                	mov    $0xfd,%dl
8010588b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010588c:	3c ff                	cmp    $0xff,%al
8010588e:	74 42                	je     801058d2 <uartinit+0x92>
  uart = 1;
80105890:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105897:	00 00 00 
8010589a:	89 fa                	mov    %edi,%edx
8010589c:	ec                   	in     (%dx),%al
8010589d:	b2 f8                	mov    $0xf8,%dl
8010589f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801058a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058a7:	00 
  for(p="xv6...\n"; *p; p++)
801058a8:	bb e8 76 10 80       	mov    $0x801076e8,%ebx
  ioapicenable(IRQ_COM1, 0);
801058ad:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801058b4:	e8 37 ca ff ff       	call   801022f0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801058b9:	b8 78 00 00 00       	mov    $0x78,%eax
801058be:	66 90                	xchg   %ax,%ax
    uartputc(*p);
801058c0:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
801058c3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
801058c6:	e8 25 ff ff ff       	call   801057f0 <uartputc>
  for(p="xv6...\n"; *p; p++)
801058cb:	0f be 03             	movsbl (%ebx),%eax
801058ce:	84 c0                	test   %al,%al
801058d0:	75 ee                	jne    801058c0 <uartinit+0x80>
}
801058d2:	83 c4 1c             	add    $0x1c,%esp
801058d5:	5b                   	pop    %ebx
801058d6:	5e                   	pop    %esi
801058d7:	5f                   	pop    %edi
801058d8:	5d                   	pop    %ebp
801058d9:	c3                   	ret    
801058da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058e0 <uartintr>:

void
uartintr(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801058e6:	c7 04 24 c0 57 10 80 	movl   $0x801057c0,(%esp)
801058ed:	e8 be ae ff ff       	call   801007b0 <consoleintr>
}
801058f2:	c9                   	leave  
801058f3:	c3                   	ret    

801058f4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801058f4:	6a 00                	push   $0x0
  pushl $0
801058f6:	6a 00                	push   $0x0
  jmp alltraps
801058f8:	e9 60 fb ff ff       	jmp    8010545d <alltraps>

801058fd <vector1>:
.globl vector1
vector1:
  pushl $0
801058fd:	6a 00                	push   $0x0
  pushl $1
801058ff:	6a 01                	push   $0x1
  jmp alltraps
80105901:	e9 57 fb ff ff       	jmp    8010545d <alltraps>

80105906 <vector2>:
.globl vector2
vector2:
  pushl $0
80105906:	6a 00                	push   $0x0
  pushl $2
80105908:	6a 02                	push   $0x2
  jmp alltraps
8010590a:	e9 4e fb ff ff       	jmp    8010545d <alltraps>

8010590f <vector3>:
.globl vector3
vector3:
  pushl $0
8010590f:	6a 00                	push   $0x0
  pushl $3
80105911:	6a 03                	push   $0x3
  jmp alltraps
80105913:	e9 45 fb ff ff       	jmp    8010545d <alltraps>

80105918 <vector4>:
.globl vector4
vector4:
  pushl $0
80105918:	6a 00                	push   $0x0
  pushl $4
8010591a:	6a 04                	push   $0x4
  jmp alltraps
8010591c:	e9 3c fb ff ff       	jmp    8010545d <alltraps>

80105921 <vector5>:
.globl vector5
vector5:
  pushl $0
80105921:	6a 00                	push   $0x0
  pushl $5
80105923:	6a 05                	push   $0x5
  jmp alltraps
80105925:	e9 33 fb ff ff       	jmp    8010545d <alltraps>

8010592a <vector6>:
.globl vector6
vector6:
  pushl $0
8010592a:	6a 00                	push   $0x0
  pushl $6
8010592c:	6a 06                	push   $0x6
  jmp alltraps
8010592e:	e9 2a fb ff ff       	jmp    8010545d <alltraps>

80105933 <vector7>:
.globl vector7
vector7:
  pushl $0
80105933:	6a 00                	push   $0x0
  pushl $7
80105935:	6a 07                	push   $0x7
  jmp alltraps
80105937:	e9 21 fb ff ff       	jmp    8010545d <alltraps>

8010593c <vector8>:
.globl vector8
vector8:
  pushl $8
8010593c:	6a 08                	push   $0x8
  jmp alltraps
8010593e:	e9 1a fb ff ff       	jmp    8010545d <alltraps>

80105943 <vector9>:
.globl vector9
vector9:
  pushl $0
80105943:	6a 00                	push   $0x0
  pushl $9
80105945:	6a 09                	push   $0x9
  jmp alltraps
80105947:	e9 11 fb ff ff       	jmp    8010545d <alltraps>

8010594c <vector10>:
.globl vector10
vector10:
  pushl $10
8010594c:	6a 0a                	push   $0xa
  jmp alltraps
8010594e:	e9 0a fb ff ff       	jmp    8010545d <alltraps>

80105953 <vector11>:
.globl vector11
vector11:
  pushl $11
80105953:	6a 0b                	push   $0xb
  jmp alltraps
80105955:	e9 03 fb ff ff       	jmp    8010545d <alltraps>

8010595a <vector12>:
.globl vector12
vector12:
  pushl $12
8010595a:	6a 0c                	push   $0xc
  jmp alltraps
8010595c:	e9 fc fa ff ff       	jmp    8010545d <alltraps>

80105961 <vector13>:
.globl vector13
vector13:
  pushl $13
80105961:	6a 0d                	push   $0xd
  jmp alltraps
80105963:	e9 f5 fa ff ff       	jmp    8010545d <alltraps>

80105968 <vector14>:
.globl vector14
vector14:
  pushl $14
80105968:	6a 0e                	push   $0xe
  jmp alltraps
8010596a:	e9 ee fa ff ff       	jmp    8010545d <alltraps>

8010596f <vector15>:
.globl vector15
vector15:
  pushl $0
8010596f:	6a 00                	push   $0x0
  pushl $15
80105971:	6a 0f                	push   $0xf
  jmp alltraps
80105973:	e9 e5 fa ff ff       	jmp    8010545d <alltraps>

80105978 <vector16>:
.globl vector16
vector16:
  pushl $0
80105978:	6a 00                	push   $0x0
  pushl $16
8010597a:	6a 10                	push   $0x10
  jmp alltraps
8010597c:	e9 dc fa ff ff       	jmp    8010545d <alltraps>

80105981 <vector17>:
.globl vector17
vector17:
  pushl $17
80105981:	6a 11                	push   $0x11
  jmp alltraps
80105983:	e9 d5 fa ff ff       	jmp    8010545d <alltraps>

80105988 <vector18>:
.globl vector18
vector18:
  pushl $0
80105988:	6a 00                	push   $0x0
  pushl $18
8010598a:	6a 12                	push   $0x12
  jmp alltraps
8010598c:	e9 cc fa ff ff       	jmp    8010545d <alltraps>

80105991 <vector19>:
.globl vector19
vector19:
  pushl $0
80105991:	6a 00                	push   $0x0
  pushl $19
80105993:	6a 13                	push   $0x13
  jmp alltraps
80105995:	e9 c3 fa ff ff       	jmp    8010545d <alltraps>

8010599a <vector20>:
.globl vector20
vector20:
  pushl $0
8010599a:	6a 00                	push   $0x0
  pushl $20
8010599c:	6a 14                	push   $0x14
  jmp alltraps
8010599e:	e9 ba fa ff ff       	jmp    8010545d <alltraps>

801059a3 <vector21>:
.globl vector21
vector21:
  pushl $0
801059a3:	6a 00                	push   $0x0
  pushl $21
801059a5:	6a 15                	push   $0x15
  jmp alltraps
801059a7:	e9 b1 fa ff ff       	jmp    8010545d <alltraps>

801059ac <vector22>:
.globl vector22
vector22:
  pushl $0
801059ac:	6a 00                	push   $0x0
  pushl $22
801059ae:	6a 16                	push   $0x16
  jmp alltraps
801059b0:	e9 a8 fa ff ff       	jmp    8010545d <alltraps>

801059b5 <vector23>:
.globl vector23
vector23:
  pushl $0
801059b5:	6a 00                	push   $0x0
  pushl $23
801059b7:	6a 17                	push   $0x17
  jmp alltraps
801059b9:	e9 9f fa ff ff       	jmp    8010545d <alltraps>

801059be <vector24>:
.globl vector24
vector24:
  pushl $0
801059be:	6a 00                	push   $0x0
  pushl $24
801059c0:	6a 18                	push   $0x18
  jmp alltraps
801059c2:	e9 96 fa ff ff       	jmp    8010545d <alltraps>

801059c7 <vector25>:
.globl vector25
vector25:
  pushl $0
801059c7:	6a 00                	push   $0x0
  pushl $25
801059c9:	6a 19                	push   $0x19
  jmp alltraps
801059cb:	e9 8d fa ff ff       	jmp    8010545d <alltraps>

801059d0 <vector26>:
.globl vector26
vector26:
  pushl $0
801059d0:	6a 00                	push   $0x0
  pushl $26
801059d2:	6a 1a                	push   $0x1a
  jmp alltraps
801059d4:	e9 84 fa ff ff       	jmp    8010545d <alltraps>

801059d9 <vector27>:
.globl vector27
vector27:
  pushl $0
801059d9:	6a 00                	push   $0x0
  pushl $27
801059db:	6a 1b                	push   $0x1b
  jmp alltraps
801059dd:	e9 7b fa ff ff       	jmp    8010545d <alltraps>

801059e2 <vector28>:
.globl vector28
vector28:
  pushl $0
801059e2:	6a 00                	push   $0x0
  pushl $28
801059e4:	6a 1c                	push   $0x1c
  jmp alltraps
801059e6:	e9 72 fa ff ff       	jmp    8010545d <alltraps>

801059eb <vector29>:
.globl vector29
vector29:
  pushl $0
801059eb:	6a 00                	push   $0x0
  pushl $29
801059ed:	6a 1d                	push   $0x1d
  jmp alltraps
801059ef:	e9 69 fa ff ff       	jmp    8010545d <alltraps>

801059f4 <vector30>:
.globl vector30
vector30:
  pushl $0
801059f4:	6a 00                	push   $0x0
  pushl $30
801059f6:	6a 1e                	push   $0x1e
  jmp alltraps
801059f8:	e9 60 fa ff ff       	jmp    8010545d <alltraps>

801059fd <vector31>:
.globl vector31
vector31:
  pushl $0
801059fd:	6a 00                	push   $0x0
  pushl $31
801059ff:	6a 1f                	push   $0x1f
  jmp alltraps
80105a01:	e9 57 fa ff ff       	jmp    8010545d <alltraps>

80105a06 <vector32>:
.globl vector32
vector32:
  pushl $0
80105a06:	6a 00                	push   $0x0
  pushl $32
80105a08:	6a 20                	push   $0x20
  jmp alltraps
80105a0a:	e9 4e fa ff ff       	jmp    8010545d <alltraps>

80105a0f <vector33>:
.globl vector33
vector33:
  pushl $0
80105a0f:	6a 00                	push   $0x0
  pushl $33
80105a11:	6a 21                	push   $0x21
  jmp alltraps
80105a13:	e9 45 fa ff ff       	jmp    8010545d <alltraps>

80105a18 <vector34>:
.globl vector34
vector34:
  pushl $0
80105a18:	6a 00                	push   $0x0
  pushl $34
80105a1a:	6a 22                	push   $0x22
  jmp alltraps
80105a1c:	e9 3c fa ff ff       	jmp    8010545d <alltraps>

80105a21 <vector35>:
.globl vector35
vector35:
  pushl $0
80105a21:	6a 00                	push   $0x0
  pushl $35
80105a23:	6a 23                	push   $0x23
  jmp alltraps
80105a25:	e9 33 fa ff ff       	jmp    8010545d <alltraps>

80105a2a <vector36>:
.globl vector36
vector36:
  pushl $0
80105a2a:	6a 00                	push   $0x0
  pushl $36
80105a2c:	6a 24                	push   $0x24
  jmp alltraps
80105a2e:	e9 2a fa ff ff       	jmp    8010545d <alltraps>

80105a33 <vector37>:
.globl vector37
vector37:
  pushl $0
80105a33:	6a 00                	push   $0x0
  pushl $37
80105a35:	6a 25                	push   $0x25
  jmp alltraps
80105a37:	e9 21 fa ff ff       	jmp    8010545d <alltraps>

80105a3c <vector38>:
.globl vector38
vector38:
  pushl $0
80105a3c:	6a 00                	push   $0x0
  pushl $38
80105a3e:	6a 26                	push   $0x26
  jmp alltraps
80105a40:	e9 18 fa ff ff       	jmp    8010545d <alltraps>

80105a45 <vector39>:
.globl vector39
vector39:
  pushl $0
80105a45:	6a 00                	push   $0x0
  pushl $39
80105a47:	6a 27                	push   $0x27
  jmp alltraps
80105a49:	e9 0f fa ff ff       	jmp    8010545d <alltraps>

80105a4e <vector40>:
.globl vector40
vector40:
  pushl $0
80105a4e:	6a 00                	push   $0x0
  pushl $40
80105a50:	6a 28                	push   $0x28
  jmp alltraps
80105a52:	e9 06 fa ff ff       	jmp    8010545d <alltraps>

80105a57 <vector41>:
.globl vector41
vector41:
  pushl $0
80105a57:	6a 00                	push   $0x0
  pushl $41
80105a59:	6a 29                	push   $0x29
  jmp alltraps
80105a5b:	e9 fd f9 ff ff       	jmp    8010545d <alltraps>

80105a60 <vector42>:
.globl vector42
vector42:
  pushl $0
80105a60:	6a 00                	push   $0x0
  pushl $42
80105a62:	6a 2a                	push   $0x2a
  jmp alltraps
80105a64:	e9 f4 f9 ff ff       	jmp    8010545d <alltraps>

80105a69 <vector43>:
.globl vector43
vector43:
  pushl $0
80105a69:	6a 00                	push   $0x0
  pushl $43
80105a6b:	6a 2b                	push   $0x2b
  jmp alltraps
80105a6d:	e9 eb f9 ff ff       	jmp    8010545d <alltraps>

80105a72 <vector44>:
.globl vector44
vector44:
  pushl $0
80105a72:	6a 00                	push   $0x0
  pushl $44
80105a74:	6a 2c                	push   $0x2c
  jmp alltraps
80105a76:	e9 e2 f9 ff ff       	jmp    8010545d <alltraps>

80105a7b <vector45>:
.globl vector45
vector45:
  pushl $0
80105a7b:	6a 00                	push   $0x0
  pushl $45
80105a7d:	6a 2d                	push   $0x2d
  jmp alltraps
80105a7f:	e9 d9 f9 ff ff       	jmp    8010545d <alltraps>

80105a84 <vector46>:
.globl vector46
vector46:
  pushl $0
80105a84:	6a 00                	push   $0x0
  pushl $46
80105a86:	6a 2e                	push   $0x2e
  jmp alltraps
80105a88:	e9 d0 f9 ff ff       	jmp    8010545d <alltraps>

80105a8d <vector47>:
.globl vector47
vector47:
  pushl $0
80105a8d:	6a 00                	push   $0x0
  pushl $47
80105a8f:	6a 2f                	push   $0x2f
  jmp alltraps
80105a91:	e9 c7 f9 ff ff       	jmp    8010545d <alltraps>

80105a96 <vector48>:
.globl vector48
vector48:
  pushl $0
80105a96:	6a 00                	push   $0x0
  pushl $48
80105a98:	6a 30                	push   $0x30
  jmp alltraps
80105a9a:	e9 be f9 ff ff       	jmp    8010545d <alltraps>

80105a9f <vector49>:
.globl vector49
vector49:
  pushl $0
80105a9f:	6a 00                	push   $0x0
  pushl $49
80105aa1:	6a 31                	push   $0x31
  jmp alltraps
80105aa3:	e9 b5 f9 ff ff       	jmp    8010545d <alltraps>

80105aa8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105aa8:	6a 00                	push   $0x0
  pushl $50
80105aaa:	6a 32                	push   $0x32
  jmp alltraps
80105aac:	e9 ac f9 ff ff       	jmp    8010545d <alltraps>

80105ab1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105ab1:	6a 00                	push   $0x0
  pushl $51
80105ab3:	6a 33                	push   $0x33
  jmp alltraps
80105ab5:	e9 a3 f9 ff ff       	jmp    8010545d <alltraps>

80105aba <vector52>:
.globl vector52
vector52:
  pushl $0
80105aba:	6a 00                	push   $0x0
  pushl $52
80105abc:	6a 34                	push   $0x34
  jmp alltraps
80105abe:	e9 9a f9 ff ff       	jmp    8010545d <alltraps>

80105ac3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105ac3:	6a 00                	push   $0x0
  pushl $53
80105ac5:	6a 35                	push   $0x35
  jmp alltraps
80105ac7:	e9 91 f9 ff ff       	jmp    8010545d <alltraps>

80105acc <vector54>:
.globl vector54
vector54:
  pushl $0
80105acc:	6a 00                	push   $0x0
  pushl $54
80105ace:	6a 36                	push   $0x36
  jmp alltraps
80105ad0:	e9 88 f9 ff ff       	jmp    8010545d <alltraps>

80105ad5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105ad5:	6a 00                	push   $0x0
  pushl $55
80105ad7:	6a 37                	push   $0x37
  jmp alltraps
80105ad9:	e9 7f f9 ff ff       	jmp    8010545d <alltraps>

80105ade <vector56>:
.globl vector56
vector56:
  pushl $0
80105ade:	6a 00                	push   $0x0
  pushl $56
80105ae0:	6a 38                	push   $0x38
  jmp alltraps
80105ae2:	e9 76 f9 ff ff       	jmp    8010545d <alltraps>

80105ae7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ae7:	6a 00                	push   $0x0
  pushl $57
80105ae9:	6a 39                	push   $0x39
  jmp alltraps
80105aeb:	e9 6d f9 ff ff       	jmp    8010545d <alltraps>

80105af0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105af0:	6a 00                	push   $0x0
  pushl $58
80105af2:	6a 3a                	push   $0x3a
  jmp alltraps
80105af4:	e9 64 f9 ff ff       	jmp    8010545d <alltraps>

80105af9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105af9:	6a 00                	push   $0x0
  pushl $59
80105afb:	6a 3b                	push   $0x3b
  jmp alltraps
80105afd:	e9 5b f9 ff ff       	jmp    8010545d <alltraps>

80105b02 <vector60>:
.globl vector60
vector60:
  pushl $0
80105b02:	6a 00                	push   $0x0
  pushl $60
80105b04:	6a 3c                	push   $0x3c
  jmp alltraps
80105b06:	e9 52 f9 ff ff       	jmp    8010545d <alltraps>

80105b0b <vector61>:
.globl vector61
vector61:
  pushl $0
80105b0b:	6a 00                	push   $0x0
  pushl $61
80105b0d:	6a 3d                	push   $0x3d
  jmp alltraps
80105b0f:	e9 49 f9 ff ff       	jmp    8010545d <alltraps>

80105b14 <vector62>:
.globl vector62
vector62:
  pushl $0
80105b14:	6a 00                	push   $0x0
  pushl $62
80105b16:	6a 3e                	push   $0x3e
  jmp alltraps
80105b18:	e9 40 f9 ff ff       	jmp    8010545d <alltraps>

80105b1d <vector63>:
.globl vector63
vector63:
  pushl $0
80105b1d:	6a 00                	push   $0x0
  pushl $63
80105b1f:	6a 3f                	push   $0x3f
  jmp alltraps
80105b21:	e9 37 f9 ff ff       	jmp    8010545d <alltraps>

80105b26 <vector64>:
.globl vector64
vector64:
  pushl $0
80105b26:	6a 00                	push   $0x0
  pushl $64
80105b28:	6a 40                	push   $0x40
  jmp alltraps
80105b2a:	e9 2e f9 ff ff       	jmp    8010545d <alltraps>

80105b2f <vector65>:
.globl vector65
vector65:
  pushl $0
80105b2f:	6a 00                	push   $0x0
  pushl $65
80105b31:	6a 41                	push   $0x41
  jmp alltraps
80105b33:	e9 25 f9 ff ff       	jmp    8010545d <alltraps>

80105b38 <vector66>:
.globl vector66
vector66:
  pushl $0
80105b38:	6a 00                	push   $0x0
  pushl $66
80105b3a:	6a 42                	push   $0x42
  jmp alltraps
80105b3c:	e9 1c f9 ff ff       	jmp    8010545d <alltraps>

80105b41 <vector67>:
.globl vector67
vector67:
  pushl $0
80105b41:	6a 00                	push   $0x0
  pushl $67
80105b43:	6a 43                	push   $0x43
  jmp alltraps
80105b45:	e9 13 f9 ff ff       	jmp    8010545d <alltraps>

80105b4a <vector68>:
.globl vector68
vector68:
  pushl $0
80105b4a:	6a 00                	push   $0x0
  pushl $68
80105b4c:	6a 44                	push   $0x44
  jmp alltraps
80105b4e:	e9 0a f9 ff ff       	jmp    8010545d <alltraps>

80105b53 <vector69>:
.globl vector69
vector69:
  pushl $0
80105b53:	6a 00                	push   $0x0
  pushl $69
80105b55:	6a 45                	push   $0x45
  jmp alltraps
80105b57:	e9 01 f9 ff ff       	jmp    8010545d <alltraps>

80105b5c <vector70>:
.globl vector70
vector70:
  pushl $0
80105b5c:	6a 00                	push   $0x0
  pushl $70
80105b5e:	6a 46                	push   $0x46
  jmp alltraps
80105b60:	e9 f8 f8 ff ff       	jmp    8010545d <alltraps>

80105b65 <vector71>:
.globl vector71
vector71:
  pushl $0
80105b65:	6a 00                	push   $0x0
  pushl $71
80105b67:	6a 47                	push   $0x47
  jmp alltraps
80105b69:	e9 ef f8 ff ff       	jmp    8010545d <alltraps>

80105b6e <vector72>:
.globl vector72
vector72:
  pushl $0
80105b6e:	6a 00                	push   $0x0
  pushl $72
80105b70:	6a 48                	push   $0x48
  jmp alltraps
80105b72:	e9 e6 f8 ff ff       	jmp    8010545d <alltraps>

80105b77 <vector73>:
.globl vector73
vector73:
  pushl $0
80105b77:	6a 00                	push   $0x0
  pushl $73
80105b79:	6a 49                	push   $0x49
  jmp alltraps
80105b7b:	e9 dd f8 ff ff       	jmp    8010545d <alltraps>

80105b80 <vector74>:
.globl vector74
vector74:
  pushl $0
80105b80:	6a 00                	push   $0x0
  pushl $74
80105b82:	6a 4a                	push   $0x4a
  jmp alltraps
80105b84:	e9 d4 f8 ff ff       	jmp    8010545d <alltraps>

80105b89 <vector75>:
.globl vector75
vector75:
  pushl $0
80105b89:	6a 00                	push   $0x0
  pushl $75
80105b8b:	6a 4b                	push   $0x4b
  jmp alltraps
80105b8d:	e9 cb f8 ff ff       	jmp    8010545d <alltraps>

80105b92 <vector76>:
.globl vector76
vector76:
  pushl $0
80105b92:	6a 00                	push   $0x0
  pushl $76
80105b94:	6a 4c                	push   $0x4c
  jmp alltraps
80105b96:	e9 c2 f8 ff ff       	jmp    8010545d <alltraps>

80105b9b <vector77>:
.globl vector77
vector77:
  pushl $0
80105b9b:	6a 00                	push   $0x0
  pushl $77
80105b9d:	6a 4d                	push   $0x4d
  jmp alltraps
80105b9f:	e9 b9 f8 ff ff       	jmp    8010545d <alltraps>

80105ba4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ba4:	6a 00                	push   $0x0
  pushl $78
80105ba6:	6a 4e                	push   $0x4e
  jmp alltraps
80105ba8:	e9 b0 f8 ff ff       	jmp    8010545d <alltraps>

80105bad <vector79>:
.globl vector79
vector79:
  pushl $0
80105bad:	6a 00                	push   $0x0
  pushl $79
80105baf:	6a 4f                	push   $0x4f
  jmp alltraps
80105bb1:	e9 a7 f8 ff ff       	jmp    8010545d <alltraps>

80105bb6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105bb6:	6a 00                	push   $0x0
  pushl $80
80105bb8:	6a 50                	push   $0x50
  jmp alltraps
80105bba:	e9 9e f8 ff ff       	jmp    8010545d <alltraps>

80105bbf <vector81>:
.globl vector81
vector81:
  pushl $0
80105bbf:	6a 00                	push   $0x0
  pushl $81
80105bc1:	6a 51                	push   $0x51
  jmp alltraps
80105bc3:	e9 95 f8 ff ff       	jmp    8010545d <alltraps>

80105bc8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105bc8:	6a 00                	push   $0x0
  pushl $82
80105bca:	6a 52                	push   $0x52
  jmp alltraps
80105bcc:	e9 8c f8 ff ff       	jmp    8010545d <alltraps>

80105bd1 <vector83>:
.globl vector83
vector83:
  pushl $0
80105bd1:	6a 00                	push   $0x0
  pushl $83
80105bd3:	6a 53                	push   $0x53
  jmp alltraps
80105bd5:	e9 83 f8 ff ff       	jmp    8010545d <alltraps>

80105bda <vector84>:
.globl vector84
vector84:
  pushl $0
80105bda:	6a 00                	push   $0x0
  pushl $84
80105bdc:	6a 54                	push   $0x54
  jmp alltraps
80105bde:	e9 7a f8 ff ff       	jmp    8010545d <alltraps>

80105be3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105be3:	6a 00                	push   $0x0
  pushl $85
80105be5:	6a 55                	push   $0x55
  jmp alltraps
80105be7:	e9 71 f8 ff ff       	jmp    8010545d <alltraps>

80105bec <vector86>:
.globl vector86
vector86:
  pushl $0
80105bec:	6a 00                	push   $0x0
  pushl $86
80105bee:	6a 56                	push   $0x56
  jmp alltraps
80105bf0:	e9 68 f8 ff ff       	jmp    8010545d <alltraps>

80105bf5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105bf5:	6a 00                	push   $0x0
  pushl $87
80105bf7:	6a 57                	push   $0x57
  jmp alltraps
80105bf9:	e9 5f f8 ff ff       	jmp    8010545d <alltraps>

80105bfe <vector88>:
.globl vector88
vector88:
  pushl $0
80105bfe:	6a 00                	push   $0x0
  pushl $88
80105c00:	6a 58                	push   $0x58
  jmp alltraps
80105c02:	e9 56 f8 ff ff       	jmp    8010545d <alltraps>

80105c07 <vector89>:
.globl vector89
vector89:
  pushl $0
80105c07:	6a 00                	push   $0x0
  pushl $89
80105c09:	6a 59                	push   $0x59
  jmp alltraps
80105c0b:	e9 4d f8 ff ff       	jmp    8010545d <alltraps>

80105c10 <vector90>:
.globl vector90
vector90:
  pushl $0
80105c10:	6a 00                	push   $0x0
  pushl $90
80105c12:	6a 5a                	push   $0x5a
  jmp alltraps
80105c14:	e9 44 f8 ff ff       	jmp    8010545d <alltraps>

80105c19 <vector91>:
.globl vector91
vector91:
  pushl $0
80105c19:	6a 00                	push   $0x0
  pushl $91
80105c1b:	6a 5b                	push   $0x5b
  jmp alltraps
80105c1d:	e9 3b f8 ff ff       	jmp    8010545d <alltraps>

80105c22 <vector92>:
.globl vector92
vector92:
  pushl $0
80105c22:	6a 00                	push   $0x0
  pushl $92
80105c24:	6a 5c                	push   $0x5c
  jmp alltraps
80105c26:	e9 32 f8 ff ff       	jmp    8010545d <alltraps>

80105c2b <vector93>:
.globl vector93
vector93:
  pushl $0
80105c2b:	6a 00                	push   $0x0
  pushl $93
80105c2d:	6a 5d                	push   $0x5d
  jmp alltraps
80105c2f:	e9 29 f8 ff ff       	jmp    8010545d <alltraps>

80105c34 <vector94>:
.globl vector94
vector94:
  pushl $0
80105c34:	6a 00                	push   $0x0
  pushl $94
80105c36:	6a 5e                	push   $0x5e
  jmp alltraps
80105c38:	e9 20 f8 ff ff       	jmp    8010545d <alltraps>

80105c3d <vector95>:
.globl vector95
vector95:
  pushl $0
80105c3d:	6a 00                	push   $0x0
  pushl $95
80105c3f:	6a 5f                	push   $0x5f
  jmp alltraps
80105c41:	e9 17 f8 ff ff       	jmp    8010545d <alltraps>

80105c46 <vector96>:
.globl vector96
vector96:
  pushl $0
80105c46:	6a 00                	push   $0x0
  pushl $96
80105c48:	6a 60                	push   $0x60
  jmp alltraps
80105c4a:	e9 0e f8 ff ff       	jmp    8010545d <alltraps>

80105c4f <vector97>:
.globl vector97
vector97:
  pushl $0
80105c4f:	6a 00                	push   $0x0
  pushl $97
80105c51:	6a 61                	push   $0x61
  jmp alltraps
80105c53:	e9 05 f8 ff ff       	jmp    8010545d <alltraps>

80105c58 <vector98>:
.globl vector98
vector98:
  pushl $0
80105c58:	6a 00                	push   $0x0
  pushl $98
80105c5a:	6a 62                	push   $0x62
  jmp alltraps
80105c5c:	e9 fc f7 ff ff       	jmp    8010545d <alltraps>

80105c61 <vector99>:
.globl vector99
vector99:
  pushl $0
80105c61:	6a 00                	push   $0x0
  pushl $99
80105c63:	6a 63                	push   $0x63
  jmp alltraps
80105c65:	e9 f3 f7 ff ff       	jmp    8010545d <alltraps>

80105c6a <vector100>:
.globl vector100
vector100:
  pushl $0
80105c6a:	6a 00                	push   $0x0
  pushl $100
80105c6c:	6a 64                	push   $0x64
  jmp alltraps
80105c6e:	e9 ea f7 ff ff       	jmp    8010545d <alltraps>

80105c73 <vector101>:
.globl vector101
vector101:
  pushl $0
80105c73:	6a 00                	push   $0x0
  pushl $101
80105c75:	6a 65                	push   $0x65
  jmp alltraps
80105c77:	e9 e1 f7 ff ff       	jmp    8010545d <alltraps>

80105c7c <vector102>:
.globl vector102
vector102:
  pushl $0
80105c7c:	6a 00                	push   $0x0
  pushl $102
80105c7e:	6a 66                	push   $0x66
  jmp alltraps
80105c80:	e9 d8 f7 ff ff       	jmp    8010545d <alltraps>

80105c85 <vector103>:
.globl vector103
vector103:
  pushl $0
80105c85:	6a 00                	push   $0x0
  pushl $103
80105c87:	6a 67                	push   $0x67
  jmp alltraps
80105c89:	e9 cf f7 ff ff       	jmp    8010545d <alltraps>

80105c8e <vector104>:
.globl vector104
vector104:
  pushl $0
80105c8e:	6a 00                	push   $0x0
  pushl $104
80105c90:	6a 68                	push   $0x68
  jmp alltraps
80105c92:	e9 c6 f7 ff ff       	jmp    8010545d <alltraps>

80105c97 <vector105>:
.globl vector105
vector105:
  pushl $0
80105c97:	6a 00                	push   $0x0
  pushl $105
80105c99:	6a 69                	push   $0x69
  jmp alltraps
80105c9b:	e9 bd f7 ff ff       	jmp    8010545d <alltraps>

80105ca0 <vector106>:
.globl vector106
vector106:
  pushl $0
80105ca0:	6a 00                	push   $0x0
  pushl $106
80105ca2:	6a 6a                	push   $0x6a
  jmp alltraps
80105ca4:	e9 b4 f7 ff ff       	jmp    8010545d <alltraps>

80105ca9 <vector107>:
.globl vector107
vector107:
  pushl $0
80105ca9:	6a 00                	push   $0x0
  pushl $107
80105cab:	6a 6b                	push   $0x6b
  jmp alltraps
80105cad:	e9 ab f7 ff ff       	jmp    8010545d <alltraps>

80105cb2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105cb2:	6a 00                	push   $0x0
  pushl $108
80105cb4:	6a 6c                	push   $0x6c
  jmp alltraps
80105cb6:	e9 a2 f7 ff ff       	jmp    8010545d <alltraps>

80105cbb <vector109>:
.globl vector109
vector109:
  pushl $0
80105cbb:	6a 00                	push   $0x0
  pushl $109
80105cbd:	6a 6d                	push   $0x6d
  jmp alltraps
80105cbf:	e9 99 f7 ff ff       	jmp    8010545d <alltraps>

80105cc4 <vector110>:
.globl vector110
vector110:
  pushl $0
80105cc4:	6a 00                	push   $0x0
  pushl $110
80105cc6:	6a 6e                	push   $0x6e
  jmp alltraps
80105cc8:	e9 90 f7 ff ff       	jmp    8010545d <alltraps>

80105ccd <vector111>:
.globl vector111
vector111:
  pushl $0
80105ccd:	6a 00                	push   $0x0
  pushl $111
80105ccf:	6a 6f                	push   $0x6f
  jmp alltraps
80105cd1:	e9 87 f7 ff ff       	jmp    8010545d <alltraps>

80105cd6 <vector112>:
.globl vector112
vector112:
  pushl $0
80105cd6:	6a 00                	push   $0x0
  pushl $112
80105cd8:	6a 70                	push   $0x70
  jmp alltraps
80105cda:	e9 7e f7 ff ff       	jmp    8010545d <alltraps>

80105cdf <vector113>:
.globl vector113
vector113:
  pushl $0
80105cdf:	6a 00                	push   $0x0
  pushl $113
80105ce1:	6a 71                	push   $0x71
  jmp alltraps
80105ce3:	e9 75 f7 ff ff       	jmp    8010545d <alltraps>

80105ce8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105ce8:	6a 00                	push   $0x0
  pushl $114
80105cea:	6a 72                	push   $0x72
  jmp alltraps
80105cec:	e9 6c f7 ff ff       	jmp    8010545d <alltraps>

80105cf1 <vector115>:
.globl vector115
vector115:
  pushl $0
80105cf1:	6a 00                	push   $0x0
  pushl $115
80105cf3:	6a 73                	push   $0x73
  jmp alltraps
80105cf5:	e9 63 f7 ff ff       	jmp    8010545d <alltraps>

80105cfa <vector116>:
.globl vector116
vector116:
  pushl $0
80105cfa:	6a 00                	push   $0x0
  pushl $116
80105cfc:	6a 74                	push   $0x74
  jmp alltraps
80105cfe:	e9 5a f7 ff ff       	jmp    8010545d <alltraps>

80105d03 <vector117>:
.globl vector117
vector117:
  pushl $0
80105d03:	6a 00                	push   $0x0
  pushl $117
80105d05:	6a 75                	push   $0x75
  jmp alltraps
80105d07:	e9 51 f7 ff ff       	jmp    8010545d <alltraps>

80105d0c <vector118>:
.globl vector118
vector118:
  pushl $0
80105d0c:	6a 00                	push   $0x0
  pushl $118
80105d0e:	6a 76                	push   $0x76
  jmp alltraps
80105d10:	e9 48 f7 ff ff       	jmp    8010545d <alltraps>

80105d15 <vector119>:
.globl vector119
vector119:
  pushl $0
80105d15:	6a 00                	push   $0x0
  pushl $119
80105d17:	6a 77                	push   $0x77
  jmp alltraps
80105d19:	e9 3f f7 ff ff       	jmp    8010545d <alltraps>

80105d1e <vector120>:
.globl vector120
vector120:
  pushl $0
80105d1e:	6a 00                	push   $0x0
  pushl $120
80105d20:	6a 78                	push   $0x78
  jmp alltraps
80105d22:	e9 36 f7 ff ff       	jmp    8010545d <alltraps>

80105d27 <vector121>:
.globl vector121
vector121:
  pushl $0
80105d27:	6a 00                	push   $0x0
  pushl $121
80105d29:	6a 79                	push   $0x79
  jmp alltraps
80105d2b:	e9 2d f7 ff ff       	jmp    8010545d <alltraps>

80105d30 <vector122>:
.globl vector122
vector122:
  pushl $0
80105d30:	6a 00                	push   $0x0
  pushl $122
80105d32:	6a 7a                	push   $0x7a
  jmp alltraps
80105d34:	e9 24 f7 ff ff       	jmp    8010545d <alltraps>

80105d39 <vector123>:
.globl vector123
vector123:
  pushl $0
80105d39:	6a 00                	push   $0x0
  pushl $123
80105d3b:	6a 7b                	push   $0x7b
  jmp alltraps
80105d3d:	e9 1b f7 ff ff       	jmp    8010545d <alltraps>

80105d42 <vector124>:
.globl vector124
vector124:
  pushl $0
80105d42:	6a 00                	push   $0x0
  pushl $124
80105d44:	6a 7c                	push   $0x7c
  jmp alltraps
80105d46:	e9 12 f7 ff ff       	jmp    8010545d <alltraps>

80105d4b <vector125>:
.globl vector125
vector125:
  pushl $0
80105d4b:	6a 00                	push   $0x0
  pushl $125
80105d4d:	6a 7d                	push   $0x7d
  jmp alltraps
80105d4f:	e9 09 f7 ff ff       	jmp    8010545d <alltraps>

80105d54 <vector126>:
.globl vector126
vector126:
  pushl $0
80105d54:	6a 00                	push   $0x0
  pushl $126
80105d56:	6a 7e                	push   $0x7e
  jmp alltraps
80105d58:	e9 00 f7 ff ff       	jmp    8010545d <alltraps>

80105d5d <vector127>:
.globl vector127
vector127:
  pushl $0
80105d5d:	6a 00                	push   $0x0
  pushl $127
80105d5f:	6a 7f                	push   $0x7f
  jmp alltraps
80105d61:	e9 f7 f6 ff ff       	jmp    8010545d <alltraps>

80105d66 <vector128>:
.globl vector128
vector128:
  pushl $0
80105d66:	6a 00                	push   $0x0
  pushl $128
80105d68:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105d6d:	e9 eb f6 ff ff       	jmp    8010545d <alltraps>

80105d72 <vector129>:
.globl vector129
vector129:
  pushl $0
80105d72:	6a 00                	push   $0x0
  pushl $129
80105d74:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105d79:	e9 df f6 ff ff       	jmp    8010545d <alltraps>

80105d7e <vector130>:
.globl vector130
vector130:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $130
80105d80:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105d85:	e9 d3 f6 ff ff       	jmp    8010545d <alltraps>

80105d8a <vector131>:
.globl vector131
vector131:
  pushl $0
80105d8a:	6a 00                	push   $0x0
  pushl $131
80105d8c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105d91:	e9 c7 f6 ff ff       	jmp    8010545d <alltraps>

80105d96 <vector132>:
.globl vector132
vector132:
  pushl $0
80105d96:	6a 00                	push   $0x0
  pushl $132
80105d98:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105d9d:	e9 bb f6 ff ff       	jmp    8010545d <alltraps>

80105da2 <vector133>:
.globl vector133
vector133:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $133
80105da4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105da9:	e9 af f6 ff ff       	jmp    8010545d <alltraps>

80105dae <vector134>:
.globl vector134
vector134:
  pushl $0
80105dae:	6a 00                	push   $0x0
  pushl $134
80105db0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105db5:	e9 a3 f6 ff ff       	jmp    8010545d <alltraps>

80105dba <vector135>:
.globl vector135
vector135:
  pushl $0
80105dba:	6a 00                	push   $0x0
  pushl $135
80105dbc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105dc1:	e9 97 f6 ff ff       	jmp    8010545d <alltraps>

80105dc6 <vector136>:
.globl vector136
vector136:
  pushl $0
80105dc6:	6a 00                	push   $0x0
  pushl $136
80105dc8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105dcd:	e9 8b f6 ff ff       	jmp    8010545d <alltraps>

80105dd2 <vector137>:
.globl vector137
vector137:
  pushl $0
80105dd2:	6a 00                	push   $0x0
  pushl $137
80105dd4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105dd9:	e9 7f f6 ff ff       	jmp    8010545d <alltraps>

80105dde <vector138>:
.globl vector138
vector138:
  pushl $0
80105dde:	6a 00                	push   $0x0
  pushl $138
80105de0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105de5:	e9 73 f6 ff ff       	jmp    8010545d <alltraps>

80105dea <vector139>:
.globl vector139
vector139:
  pushl $0
80105dea:	6a 00                	push   $0x0
  pushl $139
80105dec:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105df1:	e9 67 f6 ff ff       	jmp    8010545d <alltraps>

80105df6 <vector140>:
.globl vector140
vector140:
  pushl $0
80105df6:	6a 00                	push   $0x0
  pushl $140
80105df8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105dfd:	e9 5b f6 ff ff       	jmp    8010545d <alltraps>

80105e02 <vector141>:
.globl vector141
vector141:
  pushl $0
80105e02:	6a 00                	push   $0x0
  pushl $141
80105e04:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105e09:	e9 4f f6 ff ff       	jmp    8010545d <alltraps>

80105e0e <vector142>:
.globl vector142
vector142:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $142
80105e10:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105e15:	e9 43 f6 ff ff       	jmp    8010545d <alltraps>

80105e1a <vector143>:
.globl vector143
vector143:
  pushl $0
80105e1a:	6a 00                	push   $0x0
  pushl $143
80105e1c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105e21:	e9 37 f6 ff ff       	jmp    8010545d <alltraps>

80105e26 <vector144>:
.globl vector144
vector144:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $144
80105e28:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105e2d:	e9 2b f6 ff ff       	jmp    8010545d <alltraps>

80105e32 <vector145>:
.globl vector145
vector145:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $145
80105e34:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105e39:	e9 1f f6 ff ff       	jmp    8010545d <alltraps>

80105e3e <vector146>:
.globl vector146
vector146:
  pushl $0
80105e3e:	6a 00                	push   $0x0
  pushl $146
80105e40:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105e45:	e9 13 f6 ff ff       	jmp    8010545d <alltraps>

80105e4a <vector147>:
.globl vector147
vector147:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $147
80105e4c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105e51:	e9 07 f6 ff ff       	jmp    8010545d <alltraps>

80105e56 <vector148>:
.globl vector148
vector148:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $148
80105e58:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105e5d:	e9 fb f5 ff ff       	jmp    8010545d <alltraps>

80105e62 <vector149>:
.globl vector149
vector149:
  pushl $0
80105e62:	6a 00                	push   $0x0
  pushl $149
80105e64:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105e69:	e9 ef f5 ff ff       	jmp    8010545d <alltraps>

80105e6e <vector150>:
.globl vector150
vector150:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $150
80105e70:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105e75:	e9 e3 f5 ff ff       	jmp    8010545d <alltraps>

80105e7a <vector151>:
.globl vector151
vector151:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $151
80105e7c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105e81:	e9 d7 f5 ff ff       	jmp    8010545d <alltraps>

80105e86 <vector152>:
.globl vector152
vector152:
  pushl $0
80105e86:	6a 00                	push   $0x0
  pushl $152
80105e88:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105e8d:	e9 cb f5 ff ff       	jmp    8010545d <alltraps>

80105e92 <vector153>:
.globl vector153
vector153:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $153
80105e94:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105e99:	e9 bf f5 ff ff       	jmp    8010545d <alltraps>

80105e9e <vector154>:
.globl vector154
vector154:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $154
80105ea0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105ea5:	e9 b3 f5 ff ff       	jmp    8010545d <alltraps>

80105eaa <vector155>:
.globl vector155
vector155:
  pushl $0
80105eaa:	6a 00                	push   $0x0
  pushl $155
80105eac:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105eb1:	e9 a7 f5 ff ff       	jmp    8010545d <alltraps>

80105eb6 <vector156>:
.globl vector156
vector156:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $156
80105eb8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105ebd:	e9 9b f5 ff ff       	jmp    8010545d <alltraps>

80105ec2 <vector157>:
.globl vector157
vector157:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $157
80105ec4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105ec9:	e9 8f f5 ff ff       	jmp    8010545d <alltraps>

80105ece <vector158>:
.globl vector158
vector158:
  pushl $0
80105ece:	6a 00                	push   $0x0
  pushl $158
80105ed0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105ed5:	e9 83 f5 ff ff       	jmp    8010545d <alltraps>

80105eda <vector159>:
.globl vector159
vector159:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $159
80105edc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105ee1:	e9 77 f5 ff ff       	jmp    8010545d <alltraps>

80105ee6 <vector160>:
.globl vector160
vector160:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $160
80105ee8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105eed:	e9 6b f5 ff ff       	jmp    8010545d <alltraps>

80105ef2 <vector161>:
.globl vector161
vector161:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $161
80105ef4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105ef9:	e9 5f f5 ff ff       	jmp    8010545d <alltraps>

80105efe <vector162>:
.globl vector162
vector162:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $162
80105f00:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105f05:	e9 53 f5 ff ff       	jmp    8010545d <alltraps>

80105f0a <vector163>:
.globl vector163
vector163:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $163
80105f0c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105f11:	e9 47 f5 ff ff       	jmp    8010545d <alltraps>

80105f16 <vector164>:
.globl vector164
vector164:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $164
80105f18:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105f1d:	e9 3b f5 ff ff       	jmp    8010545d <alltraps>

80105f22 <vector165>:
.globl vector165
vector165:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $165
80105f24:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105f29:	e9 2f f5 ff ff       	jmp    8010545d <alltraps>

80105f2e <vector166>:
.globl vector166
vector166:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $166
80105f30:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105f35:	e9 23 f5 ff ff       	jmp    8010545d <alltraps>

80105f3a <vector167>:
.globl vector167
vector167:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $167
80105f3c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105f41:	e9 17 f5 ff ff       	jmp    8010545d <alltraps>

80105f46 <vector168>:
.globl vector168
vector168:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $168
80105f48:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105f4d:	e9 0b f5 ff ff       	jmp    8010545d <alltraps>

80105f52 <vector169>:
.globl vector169
vector169:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $169
80105f54:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105f59:	e9 ff f4 ff ff       	jmp    8010545d <alltraps>

80105f5e <vector170>:
.globl vector170
vector170:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $170
80105f60:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105f65:	e9 f3 f4 ff ff       	jmp    8010545d <alltraps>

80105f6a <vector171>:
.globl vector171
vector171:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $171
80105f6c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105f71:	e9 e7 f4 ff ff       	jmp    8010545d <alltraps>

80105f76 <vector172>:
.globl vector172
vector172:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $172
80105f78:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105f7d:	e9 db f4 ff ff       	jmp    8010545d <alltraps>

80105f82 <vector173>:
.globl vector173
vector173:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $173
80105f84:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105f89:	e9 cf f4 ff ff       	jmp    8010545d <alltraps>

80105f8e <vector174>:
.globl vector174
vector174:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $174
80105f90:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105f95:	e9 c3 f4 ff ff       	jmp    8010545d <alltraps>

80105f9a <vector175>:
.globl vector175
vector175:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $175
80105f9c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105fa1:	e9 b7 f4 ff ff       	jmp    8010545d <alltraps>

80105fa6 <vector176>:
.globl vector176
vector176:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $176
80105fa8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105fad:	e9 ab f4 ff ff       	jmp    8010545d <alltraps>

80105fb2 <vector177>:
.globl vector177
vector177:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $177
80105fb4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105fb9:	e9 9f f4 ff ff       	jmp    8010545d <alltraps>

80105fbe <vector178>:
.globl vector178
vector178:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $178
80105fc0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105fc5:	e9 93 f4 ff ff       	jmp    8010545d <alltraps>

80105fca <vector179>:
.globl vector179
vector179:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $179
80105fcc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105fd1:	e9 87 f4 ff ff       	jmp    8010545d <alltraps>

80105fd6 <vector180>:
.globl vector180
vector180:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $180
80105fd8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105fdd:	e9 7b f4 ff ff       	jmp    8010545d <alltraps>

80105fe2 <vector181>:
.globl vector181
vector181:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $181
80105fe4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105fe9:	e9 6f f4 ff ff       	jmp    8010545d <alltraps>

80105fee <vector182>:
.globl vector182
vector182:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $182
80105ff0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105ff5:	e9 63 f4 ff ff       	jmp    8010545d <alltraps>

80105ffa <vector183>:
.globl vector183
vector183:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $183
80105ffc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106001:	e9 57 f4 ff ff       	jmp    8010545d <alltraps>

80106006 <vector184>:
.globl vector184
vector184:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $184
80106008:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010600d:	e9 4b f4 ff ff       	jmp    8010545d <alltraps>

80106012 <vector185>:
.globl vector185
vector185:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $185
80106014:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106019:	e9 3f f4 ff ff       	jmp    8010545d <alltraps>

8010601e <vector186>:
.globl vector186
vector186:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $186
80106020:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106025:	e9 33 f4 ff ff       	jmp    8010545d <alltraps>

8010602a <vector187>:
.globl vector187
vector187:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $187
8010602c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106031:	e9 27 f4 ff ff       	jmp    8010545d <alltraps>

80106036 <vector188>:
.globl vector188
vector188:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $188
80106038:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010603d:	e9 1b f4 ff ff       	jmp    8010545d <alltraps>

80106042 <vector189>:
.globl vector189
vector189:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $189
80106044:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106049:	e9 0f f4 ff ff       	jmp    8010545d <alltraps>

8010604e <vector190>:
.globl vector190
vector190:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $190
80106050:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106055:	e9 03 f4 ff ff       	jmp    8010545d <alltraps>

8010605a <vector191>:
.globl vector191
vector191:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $191
8010605c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106061:	e9 f7 f3 ff ff       	jmp    8010545d <alltraps>

80106066 <vector192>:
.globl vector192
vector192:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $192
80106068:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010606d:	e9 eb f3 ff ff       	jmp    8010545d <alltraps>

80106072 <vector193>:
.globl vector193
vector193:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $193
80106074:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106079:	e9 df f3 ff ff       	jmp    8010545d <alltraps>

8010607e <vector194>:
.globl vector194
vector194:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $194
80106080:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106085:	e9 d3 f3 ff ff       	jmp    8010545d <alltraps>

8010608a <vector195>:
.globl vector195
vector195:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $195
8010608c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106091:	e9 c7 f3 ff ff       	jmp    8010545d <alltraps>

80106096 <vector196>:
.globl vector196
vector196:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $196
80106098:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010609d:	e9 bb f3 ff ff       	jmp    8010545d <alltraps>

801060a2 <vector197>:
.globl vector197
vector197:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $197
801060a4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801060a9:	e9 af f3 ff ff       	jmp    8010545d <alltraps>

801060ae <vector198>:
.globl vector198
vector198:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $198
801060b0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801060b5:	e9 a3 f3 ff ff       	jmp    8010545d <alltraps>

801060ba <vector199>:
.globl vector199
vector199:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $199
801060bc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801060c1:	e9 97 f3 ff ff       	jmp    8010545d <alltraps>

801060c6 <vector200>:
.globl vector200
vector200:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $200
801060c8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801060cd:	e9 8b f3 ff ff       	jmp    8010545d <alltraps>

801060d2 <vector201>:
.globl vector201
vector201:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $201
801060d4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801060d9:	e9 7f f3 ff ff       	jmp    8010545d <alltraps>

801060de <vector202>:
.globl vector202
vector202:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $202
801060e0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801060e5:	e9 73 f3 ff ff       	jmp    8010545d <alltraps>

801060ea <vector203>:
.globl vector203
vector203:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $203
801060ec:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801060f1:	e9 67 f3 ff ff       	jmp    8010545d <alltraps>

801060f6 <vector204>:
.globl vector204
vector204:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $204
801060f8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801060fd:	e9 5b f3 ff ff       	jmp    8010545d <alltraps>

80106102 <vector205>:
.globl vector205
vector205:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $205
80106104:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106109:	e9 4f f3 ff ff       	jmp    8010545d <alltraps>

8010610e <vector206>:
.globl vector206
vector206:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $206
80106110:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106115:	e9 43 f3 ff ff       	jmp    8010545d <alltraps>

8010611a <vector207>:
.globl vector207
vector207:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $207
8010611c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106121:	e9 37 f3 ff ff       	jmp    8010545d <alltraps>

80106126 <vector208>:
.globl vector208
vector208:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $208
80106128:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010612d:	e9 2b f3 ff ff       	jmp    8010545d <alltraps>

80106132 <vector209>:
.globl vector209
vector209:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $209
80106134:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106139:	e9 1f f3 ff ff       	jmp    8010545d <alltraps>

8010613e <vector210>:
.globl vector210
vector210:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $210
80106140:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106145:	e9 13 f3 ff ff       	jmp    8010545d <alltraps>

8010614a <vector211>:
.globl vector211
vector211:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $211
8010614c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106151:	e9 07 f3 ff ff       	jmp    8010545d <alltraps>

80106156 <vector212>:
.globl vector212
vector212:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $212
80106158:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010615d:	e9 fb f2 ff ff       	jmp    8010545d <alltraps>

80106162 <vector213>:
.globl vector213
vector213:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $213
80106164:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106169:	e9 ef f2 ff ff       	jmp    8010545d <alltraps>

8010616e <vector214>:
.globl vector214
vector214:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $214
80106170:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106175:	e9 e3 f2 ff ff       	jmp    8010545d <alltraps>

8010617a <vector215>:
.globl vector215
vector215:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $215
8010617c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106181:	e9 d7 f2 ff ff       	jmp    8010545d <alltraps>

80106186 <vector216>:
.globl vector216
vector216:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $216
80106188:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010618d:	e9 cb f2 ff ff       	jmp    8010545d <alltraps>

80106192 <vector217>:
.globl vector217
vector217:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $217
80106194:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106199:	e9 bf f2 ff ff       	jmp    8010545d <alltraps>

8010619e <vector218>:
.globl vector218
vector218:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $218
801061a0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801061a5:	e9 b3 f2 ff ff       	jmp    8010545d <alltraps>

801061aa <vector219>:
.globl vector219
vector219:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $219
801061ac:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801061b1:	e9 a7 f2 ff ff       	jmp    8010545d <alltraps>

801061b6 <vector220>:
.globl vector220
vector220:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $220
801061b8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801061bd:	e9 9b f2 ff ff       	jmp    8010545d <alltraps>

801061c2 <vector221>:
.globl vector221
vector221:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $221
801061c4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801061c9:	e9 8f f2 ff ff       	jmp    8010545d <alltraps>

801061ce <vector222>:
.globl vector222
vector222:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $222
801061d0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801061d5:	e9 83 f2 ff ff       	jmp    8010545d <alltraps>

801061da <vector223>:
.globl vector223
vector223:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $223
801061dc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801061e1:	e9 77 f2 ff ff       	jmp    8010545d <alltraps>

801061e6 <vector224>:
.globl vector224
vector224:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $224
801061e8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801061ed:	e9 6b f2 ff ff       	jmp    8010545d <alltraps>

801061f2 <vector225>:
.globl vector225
vector225:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $225
801061f4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801061f9:	e9 5f f2 ff ff       	jmp    8010545d <alltraps>

801061fe <vector226>:
.globl vector226
vector226:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $226
80106200:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106205:	e9 53 f2 ff ff       	jmp    8010545d <alltraps>

8010620a <vector227>:
.globl vector227
vector227:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $227
8010620c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106211:	e9 47 f2 ff ff       	jmp    8010545d <alltraps>

80106216 <vector228>:
.globl vector228
vector228:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $228
80106218:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010621d:	e9 3b f2 ff ff       	jmp    8010545d <alltraps>

80106222 <vector229>:
.globl vector229
vector229:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $229
80106224:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106229:	e9 2f f2 ff ff       	jmp    8010545d <alltraps>

8010622e <vector230>:
.globl vector230
vector230:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $230
80106230:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106235:	e9 23 f2 ff ff       	jmp    8010545d <alltraps>

8010623a <vector231>:
.globl vector231
vector231:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $231
8010623c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106241:	e9 17 f2 ff ff       	jmp    8010545d <alltraps>

80106246 <vector232>:
.globl vector232
vector232:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $232
80106248:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010624d:	e9 0b f2 ff ff       	jmp    8010545d <alltraps>

80106252 <vector233>:
.globl vector233
vector233:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $233
80106254:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106259:	e9 ff f1 ff ff       	jmp    8010545d <alltraps>

8010625e <vector234>:
.globl vector234
vector234:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $234
80106260:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106265:	e9 f3 f1 ff ff       	jmp    8010545d <alltraps>

8010626a <vector235>:
.globl vector235
vector235:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $235
8010626c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106271:	e9 e7 f1 ff ff       	jmp    8010545d <alltraps>

80106276 <vector236>:
.globl vector236
vector236:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $236
80106278:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010627d:	e9 db f1 ff ff       	jmp    8010545d <alltraps>

80106282 <vector237>:
.globl vector237
vector237:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $237
80106284:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106289:	e9 cf f1 ff ff       	jmp    8010545d <alltraps>

8010628e <vector238>:
.globl vector238
vector238:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $238
80106290:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106295:	e9 c3 f1 ff ff       	jmp    8010545d <alltraps>

8010629a <vector239>:
.globl vector239
vector239:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $239
8010629c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801062a1:	e9 b7 f1 ff ff       	jmp    8010545d <alltraps>

801062a6 <vector240>:
.globl vector240
vector240:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $240
801062a8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801062ad:	e9 ab f1 ff ff       	jmp    8010545d <alltraps>

801062b2 <vector241>:
.globl vector241
vector241:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $241
801062b4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801062b9:	e9 9f f1 ff ff       	jmp    8010545d <alltraps>

801062be <vector242>:
.globl vector242
vector242:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $242
801062c0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801062c5:	e9 93 f1 ff ff       	jmp    8010545d <alltraps>

801062ca <vector243>:
.globl vector243
vector243:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $243
801062cc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801062d1:	e9 87 f1 ff ff       	jmp    8010545d <alltraps>

801062d6 <vector244>:
.globl vector244
vector244:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $244
801062d8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801062dd:	e9 7b f1 ff ff       	jmp    8010545d <alltraps>

801062e2 <vector245>:
.globl vector245
vector245:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $245
801062e4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801062e9:	e9 6f f1 ff ff       	jmp    8010545d <alltraps>

801062ee <vector246>:
.globl vector246
vector246:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $246
801062f0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801062f5:	e9 63 f1 ff ff       	jmp    8010545d <alltraps>

801062fa <vector247>:
.globl vector247
vector247:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $247
801062fc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106301:	e9 57 f1 ff ff       	jmp    8010545d <alltraps>

80106306 <vector248>:
.globl vector248
vector248:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $248
80106308:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010630d:	e9 4b f1 ff ff       	jmp    8010545d <alltraps>

80106312 <vector249>:
.globl vector249
vector249:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $249
80106314:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106319:	e9 3f f1 ff ff       	jmp    8010545d <alltraps>

8010631e <vector250>:
.globl vector250
vector250:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $250
80106320:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106325:	e9 33 f1 ff ff       	jmp    8010545d <alltraps>

8010632a <vector251>:
.globl vector251
vector251:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $251
8010632c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106331:	e9 27 f1 ff ff       	jmp    8010545d <alltraps>

80106336 <vector252>:
.globl vector252
vector252:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $252
80106338:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010633d:	e9 1b f1 ff ff       	jmp    8010545d <alltraps>

80106342 <vector253>:
.globl vector253
vector253:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $253
80106344:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106349:	e9 0f f1 ff ff       	jmp    8010545d <alltraps>

8010634e <vector254>:
.globl vector254
vector254:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $254
80106350:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106355:	e9 03 f1 ff ff       	jmp    8010545d <alltraps>

8010635a <vector255>:
.globl vector255
vector255:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $255
8010635c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106361:	e9 f7 f0 ff ff       	jmp    8010545d <alltraps>
80106366:	66 90                	xchg   %ax,%ax
80106368:	66 90                	xchg   %ax,%ax
8010636a:	66 90                	xchg   %ax,%ax
8010636c:	66 90                	xchg   %ax,%ax
8010636e:	66 90                	xchg   %ax,%ax

80106370 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	57                   	push   %edi
80106374:	56                   	push   %esi
80106375:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106377:	c1 ea 16             	shr    $0x16,%edx
{
8010637a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010637b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010637e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106381:	8b 1f                	mov    (%edi),%ebx
80106383:	f6 c3 01             	test   $0x1,%bl
80106386:	74 28                	je     801063b0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106388:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010638e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106394:	c1 ee 0a             	shr    $0xa,%esi
}
80106397:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
8010639a:	89 f2                	mov    %esi,%edx
8010639c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801063a2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801063a5:	5b                   	pop    %ebx
801063a6:	5e                   	pop    %esi
801063a7:	5f                   	pop    %edi
801063a8:	5d                   	pop    %ebp
801063a9:	c3                   	ret    
801063aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801063b0:	85 c9                	test   %ecx,%ecx
801063b2:	74 34                	je     801063e8 <walkpgdir+0x78>
801063b4:	e8 27 c1 ff ff       	call   801024e0 <kalloc>
801063b9:	85 c0                	test   %eax,%eax
801063bb:	89 c3                	mov    %eax,%ebx
801063bd:	74 29                	je     801063e8 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
801063bf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801063c6:	00 
801063c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801063ce:	00 
801063cf:	89 04 24             	mov    %eax,(%esp)
801063d2:	e8 e9 de ff ff       	call   801042c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801063d7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801063dd:	83 c8 07             	or     $0x7,%eax
801063e0:	89 07                	mov    %eax,(%edi)
801063e2:	eb b0                	jmp    80106394 <walkpgdir+0x24>
801063e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801063e8:	83 c4 1c             	add    $0x1c,%esp
      return 0;
801063eb:	31 c0                	xor    %eax,%eax
}
801063ed:	5b                   	pop    %ebx
801063ee:	5e                   	pop    %esi
801063ef:	5f                   	pop    %edi
801063f0:	5d                   	pop    %ebp
801063f1:	c3                   	ret    
801063f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106400 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106400:	55                   	push   %ebp
80106401:	89 e5                	mov    %esp,%ebp
80106403:	57                   	push   %edi
80106404:	89 c7                	mov    %eax,%edi
80106406:	56                   	push   %esi
80106407:	89 d6                	mov    %edx,%esi
80106409:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010640a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106410:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106413:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106419:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010641b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010641e:	72 3b                	jb     8010645b <deallocuvm.part.0+0x5b>
80106420:	eb 5e                	jmp    80106480 <deallocuvm.part.0+0x80>
80106422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106428:	8b 10                	mov    (%eax),%edx
8010642a:	f6 c2 01             	test   $0x1,%dl
8010642d:	74 22                	je     80106451 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010642f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106435:	74 54                	je     8010648b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106437:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010643d:	89 14 24             	mov    %edx,(%esp)
80106440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106443:	e8 e8 be ff ff       	call   80102330 <kfree>
      *pte = 0;
80106448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010644b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106451:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106457:	39 f3                	cmp    %esi,%ebx
80106459:	73 25                	jae    80106480 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010645b:	31 c9                	xor    %ecx,%ecx
8010645d:	89 da                	mov    %ebx,%edx
8010645f:	89 f8                	mov    %edi,%eax
80106461:	e8 0a ff ff ff       	call   80106370 <walkpgdir>
    if(!pte)
80106466:	85 c0                	test   %eax,%eax
80106468:	75 be                	jne    80106428 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010646a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106470:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106476:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010647c:	39 f3                	cmp    %esi,%ebx
8010647e:	72 db                	jb     8010645b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106480:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106483:	83 c4 1c             	add    $0x1c,%esp
80106486:	5b                   	pop    %ebx
80106487:	5e                   	pop    %esi
80106488:	5f                   	pop    %edi
80106489:	5d                   	pop    %ebp
8010648a:	c3                   	ret    
        panic("kfree");
8010648b:	c7 04 24 92 70 10 80 	movl   $0x80107092,(%esp)
80106492:	e8 c9 9e ff ff       	call   80100360 <panic>
80106497:	89 f6                	mov    %esi,%esi
80106499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064a0 <seginit>:
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801064a6:	e8 15 d2 ff ff       	call   801036c0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064ab:	31 c9                	xor    %ecx,%ecx
801064ad:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
801064b2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801064b8:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064bd:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064c1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
801064c6:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064c9:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064cd:	31 c9                	xor    %ecx,%ecx
801064cf:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064d3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064d8:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064dc:	31 c9                	xor    %ecx,%ecx
801064de:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064e2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064e7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064eb:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064ed:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
801064f1:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064f5:	c6 40 15 92          	movb   $0x92,0x15(%eax)
801064f9:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064fd:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106501:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106505:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106509:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010650d:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
80106511:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106516:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010651a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010651e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106522:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106526:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010652a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010652e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106532:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106536:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010653a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010653e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106542:	c1 e8 10             	shr    $0x10,%eax
80106545:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106549:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010654c:	0f 01 10             	lgdtl  (%eax)
}
8010654f:	c9                   	leave  
80106550:	c3                   	ret    
80106551:	eb 0d                	jmp    80106560 <mappages>
80106553:	90                   	nop
80106554:	90                   	nop
80106555:	90                   	nop
80106556:	90                   	nop
80106557:	90                   	nop
80106558:	90                   	nop
80106559:	90                   	nop
8010655a:	90                   	nop
8010655b:	90                   	nop
8010655c:	90                   	nop
8010655d:	90                   	nop
8010655e:	90                   	nop
8010655f:	90                   	nop

80106560 <mappages>:
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	57                   	push   %edi
80106564:	56                   	push   %esi
80106565:	53                   	push   %ebx
80106566:	83 ec 1c             	sub    $0x1c,%esp
80106569:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010656c:	8b 55 10             	mov    0x10(%ebp),%edx
{
8010656f:	8b 7d 14             	mov    0x14(%ebp),%edi
    *pte = pa | perm | PTE_P;
80106572:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
80106576:	89 c3                	mov    %eax,%ebx
80106578:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010657e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106582:	29 df                	sub    %ebx,%edi
80106584:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106587:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
8010658e:	eb 15                	jmp    801065a5 <mappages+0x45>
    if(*pte & PTE_P)
80106590:	f6 00 01             	testb  $0x1,(%eax)
80106593:	75 3d                	jne    801065d2 <mappages+0x72>
    *pte = pa | perm | PTE_P;
80106595:	0b 75 18             	or     0x18(%ebp),%esi
    if(a == last)
80106598:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010659b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010659d:	74 29                	je     801065c8 <mappages+0x68>
    a += PGSIZE;
8010659f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801065a5:	8b 45 08             	mov    0x8(%ebp),%eax
801065a8:	b9 01 00 00 00       	mov    $0x1,%ecx
801065ad:	89 da                	mov    %ebx,%edx
801065af:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801065b2:	e8 b9 fd ff ff       	call   80106370 <walkpgdir>
801065b7:	85 c0                	test   %eax,%eax
801065b9:	75 d5                	jne    80106590 <mappages+0x30>
}
801065bb:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801065be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065c3:	5b                   	pop    %ebx
801065c4:	5e                   	pop    %esi
801065c5:	5f                   	pop    %edi
801065c6:	5d                   	pop    %ebp
801065c7:	c3                   	ret    
801065c8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
801065cb:	31 c0                	xor    %eax,%eax
}
801065cd:	5b                   	pop    %ebx
801065ce:	5e                   	pop    %esi
801065cf:	5f                   	pop    %edi
801065d0:	5d                   	pop    %ebp
801065d1:	c3                   	ret    
      panic("remap");
801065d2:	c7 04 24 f0 76 10 80 	movl   $0x801076f0,(%esp)
801065d9:	e8 82 9d ff ff       	call   80100360 <panic>
801065de:	66 90                	xchg   %ax,%ax

801065e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065e0:	a1 a4 55 11 80       	mov    0x801155a4,%eax
{
801065e5:	55                   	push   %ebp
801065e6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065e8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801065ed:	0f 22 d8             	mov    %eax,%cr3
}
801065f0:	5d                   	pop    %ebp
801065f1:	c3                   	ret    
801065f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106600 <switchuvm>:
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	57                   	push   %edi
80106604:	56                   	push   %esi
80106605:	53                   	push   %ebx
80106606:	83 ec 1c             	sub    $0x1c,%esp
80106609:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010660c:	85 f6                	test   %esi,%esi
8010660e:	0f 84 cd 00 00 00    	je     801066e1 <switchuvm+0xe1>
  if(p->kstack == 0)
80106614:	8b 46 08             	mov    0x8(%esi),%eax
80106617:	85 c0                	test   %eax,%eax
80106619:	0f 84 da 00 00 00    	je     801066f9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010661f:	8b 7e 04             	mov    0x4(%esi),%edi
80106622:	85 ff                	test   %edi,%edi
80106624:	0f 84 c3 00 00 00    	je     801066ed <switchuvm+0xed>
  pushcli();
8010662a:	e8 11 db ff ff       	call   80104140 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010662f:	e8 0c d0 ff ff       	call   80103640 <mycpu>
80106634:	89 c3                	mov    %eax,%ebx
80106636:	e8 05 d0 ff ff       	call   80103640 <mycpu>
8010663b:	89 c7                	mov    %eax,%edi
8010663d:	e8 fe cf ff ff       	call   80103640 <mycpu>
80106642:	83 c7 08             	add    $0x8,%edi
80106645:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106648:	e8 f3 cf ff ff       	call   80103640 <mycpu>
8010664d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106650:	ba 67 00 00 00       	mov    $0x67,%edx
80106655:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010665c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106663:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010666a:	83 c1 08             	add    $0x8,%ecx
8010666d:	c1 e9 10             	shr    $0x10,%ecx
80106670:	83 c0 08             	add    $0x8,%eax
80106673:	c1 e8 18             	shr    $0x18,%eax
80106676:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010667c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106683:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106689:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010668e:	e8 ad cf ff ff       	call   80103640 <mycpu>
80106693:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010669a:	e8 a1 cf ff ff       	call   80103640 <mycpu>
8010669f:	b9 10 00 00 00       	mov    $0x10,%ecx
801066a4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801066a8:	e8 93 cf ff ff       	call   80103640 <mycpu>
801066ad:	8b 56 08             	mov    0x8(%esi),%edx
801066b0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801066b6:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801066b9:	e8 82 cf ff ff       	call   80103640 <mycpu>
801066be:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801066c2:	b8 28 00 00 00       	mov    $0x28,%eax
801066c7:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801066ca:	8b 46 04             	mov    0x4(%esi),%eax
801066cd:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801066d2:	0f 22 d8             	mov    %eax,%cr3
}
801066d5:	83 c4 1c             	add    $0x1c,%esp
801066d8:	5b                   	pop    %ebx
801066d9:	5e                   	pop    %esi
801066da:	5f                   	pop    %edi
801066db:	5d                   	pop    %ebp
  popcli();
801066dc:	e9 1f db ff ff       	jmp    80104200 <popcli>
    panic("switchuvm: no process");
801066e1:	c7 04 24 f6 76 10 80 	movl   $0x801076f6,(%esp)
801066e8:	e8 73 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
801066ed:	c7 04 24 21 77 10 80 	movl   $0x80107721,(%esp)
801066f4:	e8 67 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
801066f9:	c7 04 24 0c 77 10 80 	movl   $0x8010770c,(%esp)
80106700:	e8 5b 9c ff ff       	call   80100360 <panic>
80106705:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106710 <inituvm>:
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	57                   	push   %edi
80106714:	56                   	push   %esi
80106715:	53                   	push   %ebx
80106716:	83 ec 2c             	sub    $0x2c,%esp
80106719:	8b 75 10             	mov    0x10(%ebp),%esi
8010671c:	8b 55 08             	mov    0x8(%ebp),%edx
8010671f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106722:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106728:	77 64                	ja     8010678e <inituvm+0x7e>
8010672a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
8010672d:	e8 ae bd ff ff       	call   801024e0 <kalloc>
  memset(mem, 0, PGSIZE);
80106732:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106739:	00 
8010673a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106741:	00 
80106742:	89 04 24             	mov    %eax,(%esp)
  mem = kalloc();
80106745:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106747:	e8 74 db ff ff       	call   801042c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010674c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010674f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106755:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010675c:	00 
8010675d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106761:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106768:	00 
80106769:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106770:	00 
80106771:	89 14 24             	mov    %edx,(%esp)
80106774:	e8 e7 fd ff ff       	call   80106560 <mappages>
  memmove(mem, init, sz);
80106779:	89 75 10             	mov    %esi,0x10(%ebp)
8010677c:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010677f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106782:	83 c4 2c             	add    $0x2c,%esp
80106785:	5b                   	pop    %ebx
80106786:	5e                   	pop    %esi
80106787:	5f                   	pop    %edi
80106788:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106789:	e9 d2 db ff ff       	jmp    80104360 <memmove>
    panic("inituvm: more than a page");
8010678e:	c7 04 24 35 77 10 80 	movl   $0x80107735,(%esp)
80106795:	e8 c6 9b ff ff       	call   80100360 <panic>
8010679a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067a0 <loaduvm>:
{
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
801067a3:	57                   	push   %edi
801067a4:	56                   	push   %esi
801067a5:	53                   	push   %ebx
801067a6:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
801067a9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801067b0:	0f 85 98 00 00 00    	jne    8010684e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
801067b6:	8b 75 18             	mov    0x18(%ebp),%esi
801067b9:	31 db                	xor    %ebx,%ebx
801067bb:	85 f6                	test   %esi,%esi
801067bd:	75 1a                	jne    801067d9 <loaduvm+0x39>
801067bf:	eb 77                	jmp    80106838 <loaduvm+0x98>
801067c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067ce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801067d4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801067d7:	76 5f                	jbe    80106838 <loaduvm+0x98>
801067d9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801067dc:	31 c9                	xor    %ecx,%ecx
801067de:	8b 45 08             	mov    0x8(%ebp),%eax
801067e1:	01 da                	add    %ebx,%edx
801067e3:	e8 88 fb ff ff       	call   80106370 <walkpgdir>
801067e8:	85 c0                	test   %eax,%eax
801067ea:	74 56                	je     80106842 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
801067ec:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
801067ee:	bf 00 10 00 00       	mov    $0x1000,%edi
801067f3:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
801067f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
801067fb:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106801:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106804:	05 00 00 00 80       	add    $0x80000000,%eax
80106809:	89 44 24 04          	mov    %eax,0x4(%esp)
8010680d:	8b 45 10             	mov    0x10(%ebp),%eax
80106810:	01 d9                	add    %ebx,%ecx
80106812:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106816:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010681a:	89 04 24             	mov    %eax,(%esp)
8010681d:	e8 7e b1 ff ff       	call   801019a0 <readi>
80106822:	39 f8                	cmp    %edi,%eax
80106824:	74 a2                	je     801067c8 <loaduvm+0x28>
}
80106826:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106829:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010682e:	5b                   	pop    %ebx
8010682f:	5e                   	pop    %esi
80106830:	5f                   	pop    %edi
80106831:	5d                   	pop    %ebp
80106832:	c3                   	ret    
80106833:	90                   	nop
80106834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106838:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010683b:	31 c0                	xor    %eax,%eax
}
8010683d:	5b                   	pop    %ebx
8010683e:	5e                   	pop    %esi
8010683f:	5f                   	pop    %edi
80106840:	5d                   	pop    %ebp
80106841:	c3                   	ret    
      panic("loaduvm: address should exist");
80106842:	c7 04 24 4f 77 10 80 	movl   $0x8010774f,(%esp)
80106849:	e8 12 9b ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
8010684e:	c7 04 24 f0 77 10 80 	movl   $0x801077f0,(%esp)
80106855:	e8 06 9b ff ff       	call   80100360 <panic>
8010685a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106860 <allocuvm>:
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	57                   	push   %edi
80106864:	56                   	push   %esi
80106865:	53                   	push   %ebx
80106866:	83 ec 2c             	sub    $0x2c,%esp
80106869:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010686c:	85 ff                	test   %edi,%edi
8010686e:	0f 88 8f 00 00 00    	js     80106903 <allocuvm+0xa3>
  if(newsz < oldsz)
80106874:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106877:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
8010687a:	0f 82 85 00 00 00    	jb     80106905 <allocuvm+0xa5>
  a = PGROUNDUP(oldsz);
80106880:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106886:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010688c:	39 df                	cmp    %ebx,%edi
8010688e:	77 57                	ja     801068e7 <allocuvm+0x87>
80106890:	eb 7e                	jmp    80106910 <allocuvm+0xb0>
80106892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106898:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010689f:	00 
801068a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068a7:	00 
801068a8:	89 04 24             	mov    %eax,(%esp)
801068ab:	e8 10 da ff ff       	call   801042c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801068b0:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801068b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
801068ba:	8b 45 08             	mov    0x8(%ebp),%eax
801068bd:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801068c4:	00 
801068c5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801068cc:	00 
801068cd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801068d1:	89 04 24             	mov    %eax,(%esp)
801068d4:	e8 87 fc ff ff       	call   80106560 <mappages>
801068d9:	85 c0                	test   %eax,%eax
801068db:	78 43                	js     80106920 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801068dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068e3:	39 df                	cmp    %ebx,%edi
801068e5:	76 29                	jbe    80106910 <allocuvm+0xb0>
    mem = kalloc();
801068e7:	e8 f4 bb ff ff       	call   801024e0 <kalloc>
    if(mem == 0){
801068ec:	85 c0                	test   %eax,%eax
    mem = kalloc();
801068ee:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801068f0:	75 a6                	jne    80106898 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
801068f2:	c7 04 24 6d 77 10 80 	movl   $0x8010776d,(%esp)
801068f9:	e8 52 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
801068fe:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106901:	77 47                	ja     8010694a <allocuvm+0xea>
      return 0;
80106903:	31 c0                	xor    %eax,%eax
}
80106905:	83 c4 2c             	add    $0x2c,%esp
80106908:	5b                   	pop    %ebx
80106909:	5e                   	pop    %esi
8010690a:	5f                   	pop    %edi
8010690b:	5d                   	pop    %ebp
8010690c:	c3                   	ret    
8010690d:	8d 76 00             	lea    0x0(%esi),%esi
80106910:	83 c4 2c             	add    $0x2c,%esp
80106913:	89 f8                	mov    %edi,%eax
80106915:	5b                   	pop    %ebx
80106916:	5e                   	pop    %esi
80106917:	5f                   	pop    %edi
80106918:	5d                   	pop    %ebp
80106919:	c3                   	ret    
8010691a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106920:	c7 04 24 85 77 10 80 	movl   $0x80107785,(%esp)
80106927:	e8 24 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010692c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010692f:	76 0d                	jbe    8010693e <allocuvm+0xde>
80106931:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106934:	89 fa                	mov    %edi,%edx
80106936:	8b 45 08             	mov    0x8(%ebp),%eax
80106939:	e8 c2 fa ff ff       	call   80106400 <deallocuvm.part.0>
      kfree(mem);
8010693e:	89 34 24             	mov    %esi,(%esp)
80106941:	e8 ea b9 ff ff       	call   80102330 <kfree>
      return 0;
80106946:	31 c0                	xor    %eax,%eax
80106948:	eb bb                	jmp    80106905 <allocuvm+0xa5>
8010694a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010694d:	89 fa                	mov    %edi,%edx
8010694f:	8b 45 08             	mov    0x8(%ebp),%eax
80106952:	e8 a9 fa ff ff       	call   80106400 <deallocuvm.part.0>
      return 0;
80106957:	31 c0                	xor    %eax,%eax
80106959:	eb aa                	jmp    80106905 <allocuvm+0xa5>
8010695b:	90                   	nop
8010695c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106960 <deallocuvm>:
{
80106960:	55                   	push   %ebp
80106961:	89 e5                	mov    %esp,%ebp
80106963:	8b 55 0c             	mov    0xc(%ebp),%edx
80106966:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106969:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010696c:	39 d1                	cmp    %edx,%ecx
8010696e:	73 08                	jae    80106978 <deallocuvm+0x18>
}
80106970:	5d                   	pop    %ebp
80106971:	e9 8a fa ff ff       	jmp    80106400 <deallocuvm.part.0>
80106976:	66 90                	xchg   %ax,%ax
80106978:	89 d0                	mov    %edx,%eax
8010697a:	5d                   	pop    %ebp
8010697b:	c3                   	ret    
8010697c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106980 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	56                   	push   %esi
80106984:	53                   	push   %ebx
80106985:	83 ec 10             	sub    $0x10,%esp
80106988:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010698b:	85 f6                	test   %esi,%esi
8010698d:	74 59                	je     801069e8 <freevm+0x68>
8010698f:	31 c9                	xor    %ecx,%ecx
80106991:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106996:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106998:	31 db                	xor    %ebx,%ebx
8010699a:	e8 61 fa ff ff       	call   80106400 <deallocuvm.part.0>
8010699f:	eb 12                	jmp    801069b3 <freevm+0x33>
801069a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069a8:	83 c3 01             	add    $0x1,%ebx
801069ab:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801069b1:	74 27                	je     801069da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801069b3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
801069b6:	f6 c2 01             	test   $0x1,%dl
801069b9:	74 ed                	je     801069a8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801069bb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
801069c1:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801069c4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801069ca:	89 14 24             	mov    %edx,(%esp)
801069cd:	e8 5e b9 ff ff       	call   80102330 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
801069d2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801069d8:	75 d9                	jne    801069b3 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
801069da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801069dd:	83 c4 10             	add    $0x10,%esp
801069e0:	5b                   	pop    %ebx
801069e1:	5e                   	pop    %esi
801069e2:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801069e3:	e9 48 b9 ff ff       	jmp    80102330 <kfree>
    panic("freevm: no pgdir");
801069e8:	c7 04 24 a1 77 10 80 	movl   $0x801077a1,(%esp)
801069ef:	e8 6c 99 ff ff       	call   80100360 <panic>
801069f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106a00 <setupkvm>:
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	56                   	push   %esi
80106a04:	53                   	push   %ebx
80106a05:	83 ec 20             	sub    $0x20,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106a08:	e8 d3 ba ff ff       	call   801024e0 <kalloc>
80106a0d:	85 c0                	test   %eax,%eax
80106a0f:	89 c6                	mov    %eax,%esi
80106a11:	74 75                	je     80106a88 <setupkvm+0x88>
  memset(pgdir, 0, PGSIZE);
80106a13:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a1a:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a1b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106a20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a27:	00 
80106a28:	89 04 24             	mov    %eax,(%esp)
80106a2b:	e8 90 d8 ff ff       	call   801042c0 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106a30:	8b 53 0c             	mov    0xc(%ebx),%edx
80106a33:	8b 43 04             	mov    0x4(%ebx),%eax
80106a36:	89 34 24             	mov    %esi,(%esp)
80106a39:	89 54 24 10          	mov    %edx,0x10(%esp)
80106a3d:	8b 53 08             	mov    0x8(%ebx),%edx
80106a40:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106a44:	29 c2                	sub    %eax,%edx
80106a46:	8b 03                	mov    (%ebx),%eax
80106a48:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a50:	e8 0b fb ff ff       	call   80106560 <mappages>
80106a55:	85 c0                	test   %eax,%eax
80106a57:	78 17                	js     80106a70 <setupkvm+0x70>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a59:	83 c3 10             	add    $0x10,%ebx
80106a5c:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106a62:	72 cc                	jb     80106a30 <setupkvm+0x30>
80106a64:	89 f0                	mov    %esi,%eax
}
80106a66:	83 c4 20             	add    $0x20,%esp
80106a69:	5b                   	pop    %ebx
80106a6a:	5e                   	pop    %esi
80106a6b:	5d                   	pop    %ebp
80106a6c:	c3                   	ret    
80106a6d:	8d 76 00             	lea    0x0(%esi),%esi
      freevm(pgdir);
80106a70:	89 34 24             	mov    %esi,(%esp)
80106a73:	e8 08 ff ff ff       	call   80106980 <freevm>
}
80106a78:	83 c4 20             	add    $0x20,%esp
      return 0;
80106a7b:	31 c0                	xor    %eax,%eax
}
80106a7d:	5b                   	pop    %ebx
80106a7e:	5e                   	pop    %esi
80106a7f:	5d                   	pop    %ebp
80106a80:	c3                   	ret    
80106a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106a88:	31 c0                	xor    %eax,%eax
80106a8a:	eb da                	jmp    80106a66 <setupkvm+0x66>
80106a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a90 <kvmalloc>:
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106a96:	e8 65 ff ff ff       	call   80106a00 <setupkvm>
80106a9b:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106aa0:	05 00 00 00 80       	add    $0x80000000,%eax
80106aa5:	0f 22 d8             	mov    %eax,%cr3
}
80106aa8:	c9                   	leave  
80106aa9:	c3                   	ret    
80106aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ab0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ab0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ab1:	31 c9                	xor    %ecx,%ecx
{
80106ab3:	89 e5                	mov    %esp,%ebp
80106ab5:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106abb:	8b 45 08             	mov    0x8(%ebp),%eax
80106abe:	e8 ad f8 ff ff       	call   80106370 <walkpgdir>
  if(pte == 0)
80106ac3:	85 c0                	test   %eax,%eax
80106ac5:	74 05                	je     80106acc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ac7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106aca:	c9                   	leave  
80106acb:	c3                   	ret    
    panic("clearpteu");
80106acc:	c7 04 24 b2 77 10 80 	movl   $0x801077b2,(%esp)
80106ad3:	e8 88 98 ff ff       	call   80100360 <panic>
80106ad8:	90                   	nop
80106ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ae0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	57                   	push   %edi
80106ae4:	56                   	push   %esi
80106ae5:	53                   	push   %ebx
80106ae6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106ae9:	e8 12 ff ff ff       	call   80106a00 <setupkvm>
80106aee:	85 c0                	test   %eax,%eax
80106af0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106af3:	0f 84 96 01 00 00    	je     80106c8f <copyuvm+0x1af>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106af9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106afc:	85 c0                	test   %eax,%eax
80106afe:	0f 84 ac 00 00 00    	je     80106bb0 <copyuvm+0xd0>
80106b04:	31 db                	xor    %ebx,%ebx
80106b06:	eb 51                	jmp    80106b59 <copyuvm+0x79>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106b08:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106b0e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b15:	00 
80106b16:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106b1a:	89 04 24             	mov    %eax,(%esp)
80106b1d:	e8 3e d8 ff ff       	call   80104360 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b25:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106b2b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106b2f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b36:	00 
80106b37:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106b3b:	89 44 24 10          	mov    %eax,0x10(%esp)
80106b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b42:	89 04 24             	mov    %eax,(%esp)
80106b45:	e8 16 fa ff ff       	call   80106560 <mappages>
80106b4a:	85 c0                	test   %eax,%eax
80106b4c:	78 4d                	js     80106b9b <copyuvm+0xbb>
  for(i = 0; i < sz; i += PGSIZE){
80106b4e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b54:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106b57:	76 57                	jbe    80106bb0 <copyuvm+0xd0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106b59:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5c:	31 c9                	xor    %ecx,%ecx
80106b5e:	89 da                	mov    %ebx,%edx
80106b60:	e8 0b f8 ff ff       	call   80106370 <walkpgdir>
80106b65:	85 c0                	test   %eax,%eax
80106b67:	0f 84 35 01 00 00    	je     80106ca2 <copyuvm+0x1c2>
    if(!(*pte & PTE_P))
80106b6d:	8b 30                	mov    (%eax),%esi
80106b6f:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106b75:	0f 84 1b 01 00 00    	je     80106c96 <copyuvm+0x1b6>
    pa = PTE_ADDR(*pte);
80106b7b:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106b7d:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106b83:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106b86:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106b8c:	e8 4f b9 ff ff       	call   801024e0 <kalloc>
80106b91:	85 c0                	test   %eax,%eax
80106b93:	89 c6                	mov    %eax,%esi
80106b95:	0f 85 6d ff ff ff    	jne    80106b08 <copyuvm+0x28>
  }
  
return d;

bad:
  freevm(d);
80106b9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b9e:	89 04 24             	mov    %eax,(%esp)
80106ba1:	e8 da fd ff ff       	call   80106980 <freevm>
  return 0;
80106ba6:	31 c0                	xor    %eax,%eax
}
80106ba8:	83 c4 2c             	add    $0x2c,%esp
80106bab:	5b                   	pop    %ebx
80106bac:	5e                   	pop    %esi
80106bad:	5f                   	pop    %edi
80106bae:	5d                   	pop    %ebp
80106baf:	c3                   	ret    
 uint stackTop = STACKBASE - (myproc()->stackPages * PGSIZE);
80106bb0:	e8 2b cb ff ff       	call   801036e0 <myproc>
80106bb5:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
80106bbc:	8b 40 7c             	mov    0x7c(%eax),%eax
80106bbf:	c1 e0 0c             	shl    $0xc,%eax
80106bc2:	29 45 dc             	sub    %eax,-0x24(%ebp)
  for(i = STACKBASE; i > stackTop; i -= PGSIZE) {
80106bc5:	81 7d dc fe ff ff 7f 	cmpl   $0x7ffffffe,-0x24(%ebp)
80106bcc:	0f 87 a5 00 00 00    	ja     80106c77 <copyuvm+0x197>
80106bd2:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
80106bd7:	eb 5f                	jmp    80106c38 <copyuvm+0x158>
80106bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106be0:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106be6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bed:	00 
80106bee:	89 74 24 04          	mov    %esi,0x4(%esp)
80106bf2:	89 04 24             	mov    %eax,(%esp)
80106bf5:	e8 66 d7 ff ff       	call   80104360 <memmove>
    if(mappages(d, (void*) PGROUNDDOWN(i), PGSIZE, V2P(mem), flags) < 0) {
80106bfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bfd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c04:	00 
80106c05:	89 44 24 10          	mov    %eax,0x10(%esp)
80106c09:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80106c0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106c13:	89 d8                	mov    %ebx,%eax
80106c15:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c21:	89 04 24             	mov    %eax,(%esp)
80106c24:	e8 37 f9 ff ff       	call   80106560 <mappages>
80106c29:	85 c0                	test   %eax,%eax
80106c2b:	78 55                	js     80106c82 <copyuvm+0x1a2>
  for(i = STACKBASE; i > stackTop; i -= PGSIZE) {
80106c2d:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106c33:	39 5d dc             	cmp    %ebx,-0x24(%ebp)
80106c36:	73 3f                	jae    80106c77 <copyuvm+0x197>
    if((pte = walkpgdir(pgdir, (void*) i, 0)) == 0)
80106c38:	8b 45 08             	mov    0x8(%ebp),%eax
80106c3b:	31 c9                	xor    %ecx,%ecx
80106c3d:	89 da                	mov    %ebx,%edx
80106c3f:	e8 2c f7 ff ff       	call   80106370 <walkpgdir>
80106c44:	85 c0                	test   %eax,%eax
80106c46:	74 5a                	je     80106ca2 <copyuvm+0x1c2>
    if(!(*pte & PTE_P))
80106c48:	8b 38                	mov    (%eax),%edi
80106c4a:	f7 c7 01 00 00 00    	test   $0x1,%edi
80106c50:	74 44                	je     80106c96 <copyuvm+0x1b6>
    pa = PTE_ADDR(*pte);
80106c52:	89 fe                	mov    %edi,%esi
    flags = PTE_FLAGS(*pte);
80106c54:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80106c5a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106c5d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = kalloc()) == 0)
80106c63:	e8 78 b8 ff ff       	call   801024e0 <kalloc>
80106c68:	85 c0                	test   %eax,%eax
80106c6a:	89 c7                	mov    %eax,%edi
80106c6c:	0f 85 6e ff ff ff    	jne    80106be0 <copyuvm+0x100>
80106c72:	e9 24 ff ff ff       	jmp    80106b9b <copyuvm+0xbb>
80106c77:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80106c7a:	83 c4 2c             	add    $0x2c,%esp
80106c7d:	5b                   	pop    %ebx
80106c7e:	5e                   	pop    %esi
80106c7f:	5f                   	pop    %edi
80106c80:	5d                   	pop    %ebp
80106c81:	c3                   	ret    
      kfree(mem);
80106c82:	89 3c 24             	mov    %edi,(%esp)
80106c85:	e8 a6 b6 ff ff       	call   80102330 <kfree>
      goto bad;
80106c8a:	e9 0c ff ff ff       	jmp    80106b9b <copyuvm+0xbb>
    return 0;
80106c8f:	31 c0                	xor    %eax,%eax
80106c91:	e9 12 ff ff ff       	jmp    80106ba8 <copyuvm+0xc8>
      panic("copyuvm: page not present");
80106c96:	c7 04 24 d6 77 10 80 	movl   $0x801077d6,(%esp)
80106c9d:	e8 be 96 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106ca2:	c7 04 24 bc 77 10 80 	movl   $0x801077bc,(%esp)
80106ca9:	e8 b2 96 ff ff       	call   80100360 <panic>
80106cae:	66 90                	xchg   %ax,%ax

80106cb0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106cb0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106cb1:	31 c9                	xor    %ecx,%ecx
{
80106cb3:	89 e5                	mov    %esp,%ebp
80106cb5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cbb:	8b 45 08             	mov    0x8(%ebp),%eax
80106cbe:	e8 ad f6 ff ff       	call   80106370 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106cc3:	8b 00                	mov    (%eax),%eax
80106cc5:	89 c2                	mov    %eax,%edx
80106cc7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106cca:	83 fa 05             	cmp    $0x5,%edx
80106ccd:	75 11                	jne    80106ce0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106ccf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cd4:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106cd9:	c9                   	leave  
80106cda:	c3                   	ret    
80106cdb:	90                   	nop
80106cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106ce0:	31 c0                	xor    %eax,%eax
}
80106ce2:	c9                   	leave  
80106ce3:	c3                   	ret    
80106ce4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106cf0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
80106cf5:	53                   	push   %ebx
80106cf6:	83 ec 1c             	sub    $0x1c,%esp
80106cf9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106cff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106d02:	85 db                	test   %ebx,%ebx
80106d04:	75 3a                	jne    80106d40 <copyout+0x50>
80106d06:	eb 68                	jmp    80106d70 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d08:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d0b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d0d:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106d11:	29 ca                	sub    %ecx,%edx
80106d13:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106d19:	39 da                	cmp    %ebx,%edx
80106d1b:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106d1e:	29 f1                	sub    %esi,%ecx
80106d20:	01 c8                	add    %ecx,%eax
80106d22:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d26:	89 04 24             	mov    %eax,(%esp)
80106d29:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106d2c:	e8 2f d6 ff ff       	call   80104360 <memmove>
    len -= n;
    buf += n;
80106d31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106d34:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106d3a:	01 d7                	add    %edx,%edi
  while(len > 0){
80106d3c:	29 d3                	sub    %edx,%ebx
80106d3e:	74 30                	je     80106d70 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106d40:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106d43:	89 ce                	mov    %ecx,%esi
80106d45:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106d4b:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106d4f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106d52:	89 04 24             	mov    %eax,(%esp)
80106d55:	e8 56 ff ff ff       	call   80106cb0 <uva2ka>
    if(pa0 == 0)
80106d5a:	85 c0                	test   %eax,%eax
80106d5c:	75 aa                	jne    80106d08 <copyout+0x18>
  }
  return 0;
}
80106d5e:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106d61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d66:	5b                   	pop    %ebx
80106d67:	5e                   	pop    %esi
80106d68:	5f                   	pop    %edi
80106d69:	5d                   	pop    %ebp
80106d6a:	c3                   	ret    
80106d6b:	90                   	nop
80106d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d70:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106d73:	31 c0                	xor    %eax,%eax
}
80106d75:	5b                   	pop    %ebx
80106d76:	5e                   	pop    %esi
80106d77:	5f                   	pop    %edi
80106d78:	5d                   	pop    %ebp
80106d79:	c3                   	ret    
80106d7a:	66 90                	xchg   %ax,%ax
80106d7c:	66 90                	xchg   %ax,%ax
80106d7e:	66 90                	xchg   %ax,%ax

80106d80 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80106d86:	c7 44 24 04 14 78 10 	movl   $0x80107814,0x4(%esp)
80106d8d:	80 
80106d8e:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106d95:	e8 f6 d2 ff ff       	call   80104090 <initlock>
  acquire(&(shm_table.lock));
80106d9a:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106da1:	e8 da d3 ff ff       	call   80104180 <acquire>
80106da6:	b8 f4 55 11 80       	mov    $0x801155f4,%eax
80106dab:	90                   	nop
80106dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80106db0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106db6:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80106db9:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80106dc0:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (i = 0; i< 64; i++) {
80106dc7:	3d f4 58 11 80       	cmp    $0x801158f4,%eax
80106dcc:	75 e2                	jne    80106db0 <shminit+0x30>
  }
  release(&(shm_table.lock));
80106dce:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106dd5:	e8 96 d4 ff ff       	call   80104270 <release>
}
80106dda:	c9                   	leave  
80106ddb:	c3                   	ret    
80106ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106de0 <shm_open>:

int shm_open(int id, char **pointer) {
80106de0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106de1:	31 c0                	xor    %eax,%eax
int shm_open(int id, char **pointer) {
80106de3:	89 e5                	mov    %esp,%ebp
}
80106de5:	5d                   	pop    %ebp
80106de6:	c3                   	ret    
80106de7:	89 f6                	mov    %esi,%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106df0 <shm_close>:


int shm_close(int id) {
80106df0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106df1:	31 c0                	xor    %eax,%eax
int shm_close(int id) {
80106df3:	89 e5                	mov    %esp,%ebp
}
80106df5:	5d                   	pop    %ebp
80106df6:	c3                   	ret    
