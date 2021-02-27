# linux-uwu

linux-uwu is an optimized low-latency kernel based on the vanilla Linux sources. It uses a few patches, including graysky2's gcc optimization patch, Gabriel Krisman's fsync patch, a few CLR patches, and the Clang LTO patches that are set to be included in 5.12, which all adds up into a kernel that should be faster than the vanilla kernel.

Note: linux-uwu has only been tested on Debian sid running on amd64, so I can't guarantee that it'll work and/or compile on other distributions and/or other architectures.

# NFAQ - Not so Frequently Asked Questions

> Q: Why does this exist when Liquorix/zen exists?

A: Partly because I just enjoy doing this, and partly because Liquorix/zen is kind of slow (see [this article](https://www.phoronix.com/scan.php?page=article&item=radeon-gaming-liquorix54)), and the latency is noticeably higher than on a standard low-latency kernel. This is, as far as I know, caused by the BMQ scheduler, which is still not as mature as the default CFS scheduler. I could be wrong, though.

> Q: Why doesn't this kernel include the PREEMPT_RT patches?

A: Because it breaks support for the proprietary NVIDIA drivers. I might look into making a separate PREEMPT_RT branch at some point, but I'll be unable to test it.

> Q: How do I compile it?

A: Just run build.sh! Note that you'll need Debian or a Debian-based distro to compile it, and that it has only been tested on Debian sid running on amd64.

> Q: I'd like x patch to be added!

A: Open an issue with a link to the patch and I'll take a look at it and see if it's appropriate to include it.
