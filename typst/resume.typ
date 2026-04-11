#import "templates/resume.template.typ" : *

#show: resume.with(
  author: "Zebang He",
  // location: "Shanghai, China",
  contacts: (
    [#emoji.mail #link("mailto:hezambar@outlook.com")[hezambar\@outlook.com]],
    [#emoji.phone +86 155-8000-7649],
    [#emoji.globe.meridian #link("https://zambar.dev")[zambar.dev]],
    [Github: #link("https://github.com/HeZeBang")[HeZeBang]],
  ),
  // footer: [#align(center)[#emph[References available on request]]]
)

= /*#emoji.mortarboard*/ Education

#edu(
  institution: "ShanghaiTech University",
  date: "2023 - Present",
  location: "Shanghai, China",
  degrees: (
    ("Undergraduate", "Computer Science"),
  ),
)

#edu(
  institution: "Shanghai Jiao Tong University - IPADS Lab",
  date: "2025",
  location: "Shanghai, China",
  degrees: (
    ("Research Assistant", "MLSys @ Zhichao Hua"),
  ),
)

#v(-0.5em)
*Research Interests*:
    I am currently focusing on _*computer architecture*_, _*high performance*_ and _*intelligent storage*_, with a particular focus on optimizing heterogeneous computing and parallel computing, as well as high-concurrency and distributed file system.

= Internships

#exp(
  role: "System Dev",
  project: "SiFlow/Scitix (UbiQuant)",
  summary: "AI Infra - Distributed storage / cache system. Connects to LMCache.",
  date: "Sep 2025 - Nov 2025",
  tech: "C++, Python, k8s",
  details: [
    - I was responsible for developing the dynamic scaling and failover features for distributed storage, and I implemented a task queue based on a sliding window to avoid performance spikes.
    - I also wrote correctness tests and a large number of unit tests for the project to ensure that the functions worked properly.
  ]
)
= /*#emoji.lightbulb*/ Skills
#skills((
  ("Expertise", (
    [HPC],
    [Architecture],
    [OS],
    [Compiler],
    [Full-stack Developing],
    [Product Design],
  )),
  // ("Development", (
  //   [
  //     // React, 
  //     // Next.js, 
  //     // Node.js; 
  //     // Flask, 
  //     // MAUI/Xamarin;
  //     // Gin; 
  //     // Redis; 
  //   ],
  // )),
  ("Languages", (
    [`Python`],
    [`C/C++`],
    [`Javascript/Typescript`],
    [`Rust`],
    [`OCaml`],
    [`C#`],
    [`Golang`],
    [`LaTeX/Typst`]
  )),
))

= Competitions

#exp(
  role: "Software First Prize",
  project: "RED Hackathon",
  date: "2026. Apr.",
  tech: "ComfyUI, k8s, Python",
  summary: "Hacker Maration by Red Note",
  details: [
    - We've developed a TikTok-like hair style APP *in 48-hours* named *ChicChic*, and won the first prize with many investments.
    - I developed ComfyUI workflow to implement facial transition and video generation. I also developed a load-balance router with many optimizations on parallelism on ComfyUI, supporting inference with many cards simultaneously.
  ]
)

#exp(
  role: "Special Prize (Rank 1st)",
  project: "NSCSCC 2025 (Loongson Cup)",
  date: "2025 Jun.",
  tech: "Verilog, Vivado, C, ASM",
  summary: "National Student Computer System Capability Challenge",
  details: [
    - We are designing a *high-performance* chip supporting the *LoongArch* instruction set on the FPGA of the Artix-7 kit. And *we've defeated Tsinghua University and Fudan University, ranked 1st!*
    - We have run the *Linux system* on this chip and ported specific programs, performing targeted *profiling* and *optimization* for the performance of those specific programs.
  ]
)

// #exp(
//   role: "Ongoing",
//   project: "MCC 2025",
//   date: "Ongoing...",
//   summary: "Marine Computing Challenge",
//   tech: "FORTRAN, openEuler, Hyper MPI",
//   details: [
//     - We're optimizing CESM's(Community Earth System Model) performance on Kirin CPU with openEuler system.
//     - We have analyzed the performance based on Kirin's chip architecture and the communication bottleneck of 200 nodes, and are adjusting the algorithm of scheduling and resource allocation  in FORTRAN to optimize the performance.
//     - We also used the Kunpeng Math Library (KML) and Hyper MPI for architecturally targeted optimizations.
//   ]
// )

#exp(
  role: "2'nd Prize",
  project: "ASC 25",
  date: "2025 Jan.",
  summary: "Student supercomputing challenge of ASC",
  tech: "Slurm, C, Python, ARM-Forge",
  details: [
    - We have optimized *HPL* and *HPCG* with special tuning based on the CPU and GPU architectures we use, allowing them to achieve more than 90% of the theoretical results!
    - We've transferred *AlphaFold3* from GPU to CPU, and we've done some optimizations.
  ]
)

// #pagebreak(weak: true)

= /*#emoji.globe.meridian*/ Projects

// #exp(
//   role: "Frontend Develop",
//   project: "MX OJ Development",
//   date: "May 2024 - Present",
//   summary: "A online judge system for the ACM/OI station.",
//   tech: "React + Next.js, Zod, Next UI",
//   details: [
//     - We used React + Next.js with Zod, Next UI to develop the front-end of the online judge system.
//     - My contribution: I implemented the front-end design and development of the station's letters and made adjustments for typographic optimization.
//   ]
// )

// #exp(
//   role: "Full-stack Develop, DevOps",
//   project: "CourseBench",
//   date: "May 2024 - Present",
//   summary: "The greatest course election community in ShanghaiTech.",
//   tech: "Vue.js + PostgreSQL + Go + k8s",
//   details: [
//     - Available at https://coursebench.geekpie.club
//     - I implemented some backend feature and corresponding front-end design.
//     - I improved the CI/CD pipeline and the deployment process. And I'm now working on the Kubernetes DevOps.
//   ]
// )

// #exp(
//   role: "Full-stack Develop",
//   project: "CatLin",
//   date: "2025 Spring",
//   summary: "CatLin is a Deadline Manager with Kawaii Interface",
//   tech: "React + Next.js + Flask + SQLite",
//   details: [
//     - Available at #link("https://github.com/HeZeBang/CatLin")
//     - I used React + Next.js with Flask, SQLite to develop the front-end and back-end of the deadline manager.
//     - My contribution: I implemented the front-end design and development of the backend.
//   ]
// )

// #exp(
//   role: "Embedded, Unity reverse Developing",
//   project: "Arcade Game Making",
//   date: "Mar 2024 - May 2024",
//   summary: "Implement Arcade Rythm Game by using SAMD32, Arduino.",
//   tech: "Arduino, C# + Unity",
//   details: [
//     - I used Arduino C to develop the Key input with Arduino, and used SAMD32 to Implement the touch simulation with area capacitive touch (Using ITO film and copper foil).
//     - I also used C\# to decompile the Unity game's main logic to simulate IO4 input, and used Python to implement basic hooking to improve the gaming experience.
//   ]
// )

// #exp(
//   role: "Backend Develop",
//   project: "Growth Document System of College",
//   date: "Mar 2023 - Present",
//   summary: "Manage student growth profiles, and integrate into official school platform.",
//   tech: "Golang + Gin + Gorm + PostgreSQL",
//   details: [
//     - I'm developing the backend of the growth document system of the college using Gin + Gorm + PostgreSQL. And it's ready to be integrated into the official school platform.
//   ]
// )

// #exp(
//   role: "Personal Project",
//   project: [#link("https://github.com/HeZeBang/HollyDDL")[Holly DDL]],
//   summary: "A website tool for students to checking ddls from different platforms all on one site.\n Using React + Python",
//   date: "May 2024",
//   details: [
//     - I captured and analyzed the API of different platforms, and developed a website tool.
//     - I used React + MUI to develop the frontend, and Python to develop the backend. It's now available on Github and Vercel.
//   ]
// )

#exp(
  role: "Jump Trading School Project",
  project: "JPO - An Order-Based Market Data feed",
  date: "Oct 2025",
  summary: "An efficient implementation of orderbook.",
  tech: "C++",
  details: [
    - I implemented an efficient orderbook with high efficiency. Profiled between different hash implementation, high performance data structure and algorithms.
    - Supports Augumented BST Tree to trace history, uses Flat Hashmap, and optimized in instruction-level with Intel VTune to be cache friendlier.
  ]
)

#exp(
  role: "OSPP Personal Project",
  project: "GCC-Fortran with Multi-Versioning Support",
  date: "Jun 2025 - July 2025",
  summary: "Function Multi-Versioning `target_clones` support for GFortran compiler.",
  tech: "C, C++, Fortran",
  details: [
    - I implemented the correct registration and parsing of `ATTRIBUTE` in the frontend, implemented the attribute handling function, and modified the `IFUNC` function generation mechanism.
    // - This project is still in its final stages, with documentation being written and awaiting GCC upstream merging.
  ]
)

#exp(
  role: "Personal",
  project: "TrackMaker-rs",
  date: "Feb 2024 - Jun 2025",
  summary: "Audio-based Ethernet Implementation, support ICMP/TCP/UDP/DNS",
  tech: "Rust",
  details: [
    - I implemented a ethernet interface based on acoustic link (by AUX wire or by sound). Using WLAN-like protocal to support multiple access.
    - Based on physical layer, I implemented other internet layers, including TCP/UDP/ICMP/DNS and other protocals.
  ]
)

#exp(
  role: "Personal",
  project: "PintOS",
  date: "Mar 2024 - Jun 2024",
  summary: "An operating system for the 80x86 architecture.",
  tech: "C, x86 Assembly",
  details: [
    - I implemented the advanced scheduling, system call, user/kernel mode, virtual memory and file system of the operating system.
    - PintOS contains basic shell and filesystem, and is able to run programs in user mode.
  ]
)

#exp(
  role: "Personal",
  project: "OATC Language Compiler",
  date: "Aug 2024 - Jan 2025",
  tech: "OCaml, LLVM, X86lite", 
  summary: "A simple language compiler for the OATC language.",
  details: [
    - I implemented an X86lite instruction set simulator and assembler. And the OATC language interpreter using OCaml.
    - I've also developed the compiler from OATC to LLVMlite IR, and final to X86lite platform.
  ]
)

// #exp(
//   role: "Personal",
//   project: "RISC-V RV32I CPU with pipeline",
//   date: "Feb 2024 - Jun 2025",
//   summary: "A full-function RV32I CPU, with 5 stages & hazard solving",
//   tech: "RISCV, Logisim",
//   details: [
//     // - I designed a simple CPU which is turing complete, and it supports RISC-V RV32I standard.
//     - My CPU supports a classic five-stage pipeline capable of handling structure adventures, data adventures, and control adventures.
//   ]
// )

// #exp(
//   role: "Personal",
//   project: "Efficient hash implementation of CHACHA20 + Merkle Tree",
//   tech: "C, AVX, OMP",
//   date: "May, 2023",
//   summary: "Using Intel AVX with OpenMP and PThread, reached 35x performance improvement.",
//   details: [
//     - I developed a new high-performance hash implementation based on CHACHA20 and Merkle Tree, utilized Intel's AVX technology, OpenMP and PThreads for multithreading, and thread pool technology to maximize CPU utilization.
//     - The runtime efficiency improved by 35 times compared to the original version and by more than 4 times compared to Bare OpenMP + O3.
//   ]
// )

// #exp(
//   role: "Personal Project",
//   project: "QRTech-web",
//   date: "Sep 2023 - Present",
//   summary: "Real-time Wide-Area-Network Data Broadcasting.",
//   tech: "React + Golang + WebRTC; Redis + SQLite",
//   details: [
//     - My project focuses on developing a wide area network data broadcasting system, aimed at sharing datas with short lifecycle within short time.
//     // - I'm dealing with high concurrency while being able to use P2P (WebRTC) to achieve data acceleration and save as much traffic as possible. Uses Redis to quickly store and retrieve data.
//   ]
// )

// #exp(
//   role: "Contributor",
//   project: "Desktop Lyric",
//   date: "2024-2025",
//   summary: "An GNOME extention that shows the lyric of playing songs on the desktop. ",
//   tech: "GJS, DBus",
//   details: [
//     - Available at #link("https://github.com/tuberry/desktop-lyric")
//     - I contributed to the project by implementing the lyric fetching and displaying logic.
//     - I'm now working on the lyric translation feature. And adding more motions by using Cairo.
//   ]
// )

// #exp(
//   role: "Personal Project",
//   project: "Tiny CPU with ZASM",
//   date: "Dec 2023 - Aug 2024",
//   summary: "A simple CPU with ZASM which defined by myself.",
//   tech: "Verilog, ZASM",
//   details: [
//     - I designed a simple CPU which is turing complete, and it supports 8-bit instructions and interger calculations. It contains 8 registers and 256 bytes of memory.
//     - I made a simple instruction set and named it "ZASM", it contains 20+ instructions, including function calls, jumps and basic arithmetic and logic operations.
//   ]
// )

= /*#emoji.books*/ Roles

#exp(
  role: "President",
  project: "GeekPie Association, GeekPie HPC Team",
  // summary: "A comprehensive technology-based science and innovation society",
  summary: [I'm the *president of GeekPie Association*, a comprehensive technology-based science and innovation society. I'm also the *team leader of the GeekPie HPC team*, participated in ASC/SCC/ISC.],
  // date: "Feb 2024 - Present",
)

// #exp(
//   role: "Team Member",
//   project: "GeekPie HPC Team",
//   summary: "I'm a member of the GeekPie HPC team, preparing for the IndySCC 2024.",
//   date: "June 2024 - Present"
// )

// #exp(
//   role: "Instructor & Main Developer",
//   project: "SI 100+ / Intro to Computer Science",
//   // date: "Sep 2024 - Present",
//   summary: [I'm the *main instructor* and person in charge of the course SI 100+ for freshmen in ShanghaiTech.]
// )

// = Internships

// #exp(
//   role: "Fullstack Dev",
//   project: "Grained.AI",
//   // date: "Sep 2024 - Present",
//   summary: [I'm the *main instructor* and person in charge of the course SI 100+ for freshmen in ShanghaiTech.]
// )
