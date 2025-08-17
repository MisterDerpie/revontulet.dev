---
title: AI-first - We're just 6 months away from AGI ;-)
description: Yet another review of where CEOs and AI are taking us at the moment.
slug: 2025-ai-first
date: 2025-05-31 10:00:00+0000
categories:
    - Tech-Views
tags:
    - Opinion
    - AI
keywords:
    - AI
    - AI-first
    - Artificial Intelligence
    - ChatGPT
    - Cursor
    - Windsurf
    - AGI
weight: 1
---

{{< quote author="The Matrix" source="Almost The Matrix" url="https://www.imdb.com/title/tt0133093/quotes/">}}
The ~Matrix~ *AI* is everywhere.
It is all around us.
Even now, in this very room.
You can see it when you look ~out your window~ *something up on the internet* or when you turn on your ~television~ *washing machine*.
You can feel it when you go to ~work~ *do anything nowadays*... 
when you go to ~church~ a *search engine*... 
when you ~pay~ *fill out* your taxes.
It is the world that has been pulled over your eyes to blind you from ~the truth~ *meaningful content*.
{{< /quote >}}

Today's AI world reminds me a lot of The Matrix.
For about two years, we have been living in a world where AI has become the new Nocode, the new Bitcoin, the new Web3, the new Metaverse, basically everything.
It is hardly possible to not encounter AI on, in, over, under, everywhere around us.

If I would like to, I could connect my washing machine to the internet.
There is even an AI stamp!
Whyever that needs AI, my laundry was clean 5 years ago, and my washing machine is still offline, and shall always be.

## Why this post?

Whilst being on a bus ride across Germany, I was thinking about the latest news in tech, my work, and to no one's surprise: AI.
Over the course of the past months, we all have been reading more (or less) on AI.
Sales pitches have been made that it is the past, the present, the future, drawing a resemblance to the Matrix: "It is all around us."
Predicting the future is impossible (even with AI, sorry to break it like this to you), but if you just predict every possible outcome, by definition one scenario turns out to be true.
We see wild claims and heavy doubts, and have the full spectrum of predictions.

"AI-first" movements are popping up everywhere, but let's just have a look on where ~we are~ some of it is, and where some of us are now.

## Success Stories?

Whilst nobody can tell what AI-first exactly is, it seems to be AI doing work that humans will not be needed for anymore.
Sometimes for better, sometimes for worse.
Two examples where the "all-in" resulted in at least "some-out"

Klarna:

* 2024 - [Klarna's AI assistant is doing the job of 700 workers](https://www.forbes.com/sites/jackkelly/2024/03/04/klarnas-ai-assistant-is-doing-the-job-of-700-workers-company-says/?sh=2cd6858317ae)
([archive.is](https://archive.is/o7KnK))
* 2025 - Feb - [2/3 of customer service is AI assistants at Klarna](https://www.klarna.com/international/press/klarna-ai-assistant-handles-two-thirds-of-customer-service-chats-in-its-first-month/)
([archive.is](https://archive.is/90KR5))
* 2025 - May - [Klarna rehires humans to ensure customers can always talk to humans](https://www.bloomberg.com/news/articles/2025-05-08/klarna-turns-from-ai-to-real-person-customer-service)
([archive.is](https://archive.is/lRplR))

Duolingo: 

* 2025 - April - [Duolingo will replace contract workers with AI](https://www.theverge.com/news/657594/duolingo-ai-first-replace-contract-workers)
([archive.is](https://archive.is/wKtVL))
* 2025 - May - [Duolingo Faces Backlash Over AI Strategy, Pivots to Retract Its Statement](https://www.thehrdigest.com/duolingo-faces-backlash-over-ai-strategy-pivots-to-retract-its-statement/)
([archive.is](https://archive.is/GwcJC))

At the same time, we hear great success stories from the really big tech companies.

* 2024 - Amazon - [Amazon CEO Andy Jassy Says Company's AI Assistant Has Saved $260M And 4.5K Developer-Years Of Work](https://finance.yahoo.com/news/amazon-ceo-andy-jassy-says-213018283.html)
([archive.is](https://archive.is/xcqF8))
* 2025 - Google - [AI Powers 25% of Google’s Code](https://www.forbes.com/sites/jackkelly/2024/11/01/ai-code-and-the-future-of-software-engineers/)
([archive.is](https://archive.is/tjGKq))

Amazon and Google are boasting about their success stories, without providing much data.
But luckily, we can find that data ourselves, for instance, on Open Source projects... or can we?
The blog "Pivot to AI" published the article
[If AI is so good at coding … where are the open source contributions?](https://pivot-to-ai.com/2025/05/13/if-ai-is-so-good-at-coding-where-are-the-open-source-contributions/),
and the result should make all of us wonder...

Oftentimes, companies get away making these bold claims without ever proving them.
We don't see the methodology Amazon used to come up with 4,500 developer years.
Was that even work that was necessary in the first place?
Say you have a staple of dirty dishes and a trashbin having only an empty milk carton.
You could empty the bin, but that's clearly not needed and the dishes won't be done either.
What kind of Code is Google referring to, and how much longer would it take a human to produce it?
It should be easy to reproduce their results on FOSS.

As with any _new_ technology, it is just sufficient to make a bold claim.
Those asking about evidence are met with "It's true, but I will not make the effort to prove it to you because you won't believe me anyway."
Consequently, no need to give proof, right?

Side-Note: I am aware that there are LLM benchmarks.
Coming from "It solved a well-defined undergrad test" to AGI or above claims is imho too big of a gap, that has yet to be filled.
An article about one of GitHub's actual benchmarks is
[Does GitHub Copilot Improve Code Quality? Here's How We Lie With Statistics](https://jadarma.github.io/blog/posts/2024/11/does-github-copilot-improve-code-quality-heres-how-we-lie-with-statistics/)
([archive.is](https://archive.is/4fbdQ)) from Jadarma's blog... which draws a grim picture on the methodology.

To our luck, there's been a public experiment.
Recently (May 2025), .NET Developers tried out Copilot on their GitHub repository, see PR [github/dotnet/runtime#115762](https://github.com/dotnet/runtime/pull/115762).
Whilst there are a lot of snarky comments, I think we should respect the attempt.
It is important to see where we stand, and see where we can improve, or whether we aren't there (yet?).
Have a look at it yourself, it's worth it.
In this experiment, AI could unfortunately not live up to the standard of what CEOs are telling shareholders.
Instead, the closest resemblance would be a _Fiebertraum_ (German for feverish dreams, basically a nightmare).

## We are only six months away from AGI!

This statement can probably not be attributed to just one single person, as it is mostly used in a mocking way.
Ever since ChatGPT, we heard how all kinds of jobs are going to be cut, engineers are put out of work, and prompt-engineering is the future.

Without doubt, AI has made it into our toolbelt.
Similar to other tools engineers use.
For example, opening a documentation to see how to use a technology.
Reading a book for a deep dive into inner workings.
Optimizing memory layout for making use of Cache Lanes.
Opening Google Search to crawl Stackoverflow.

The list of tools, technologies and techniques engineers can use are near endless.
And AI is yet another one that helps us.

However, looking back at history

* Compilers didn't replace the need for engineers
* Google didn't make books obsolete
* No-Code anyone?
* ...

## The questionable speedup of AI(-first)

Talking with peers in my field, which is distributed systems and backend engineering, we see our CEOs and CTOs moving to "AI-first" codebases.
With AI code editors like Cursor and Windsurf (the latter [soon to be Open AI](https://www.reuters.com/business/openai-agrees-buy-windsurf-about-3-billion-bloomberg-news-reports-2025-05-06/)
([archive.is](https://archive.is/BIk0g))), engineers are able to not just prompt for snippets, but use their whole codebase as the underlying dataset.

When you try Cursor, ChatGPT,... for the first time, it is very impressive how quickly it achieves a prototype of what you imagine.
If you ever attempted to build a GUI by just drawing a rectangle and reacting to the mouse events, extracting coordinates etc., you probably know how much code that needs.
Compare that to e.g. HTML, where creating a button in a few lines of code is the way, and executing an action on mouse click is as easy passing a function to a method named like the action itself.
Coming from the lower level of things, this will speed up your GUI building 10x, without a doubt.
You are now able to achieve even more in a shorter time - but what kind of work?
This brings me to the Pareto Principle, which most of us should be familiar with.

{{< quote author="Joseph M. Juran" source="Wikipedia" url="https://en.wikipedia.org/wiki/Pareto_principle">}}
The Pareto principle (also known as the 80/20 rule,
the law of the vital few and the principle of factor sparsity) states that for many outcomes,
roughly 80% of consequences come from 20% of causes (the "vital few").
{{< /quote >}}

Simply put, you spend 20% of your time to achieve 80% of your goals, but the remaining 20% is where you actually spend the vast majority.
What has always been hard were the last 20%.
To actually bring it over the finish line requires a lot of effort after the "quick and dirty" part is done - again, this is where we spend most of our time.
Frameworks, higher level languages, compilers...
They all have in common to reduce the first 80% of our work, but do not eliminate 80% of our time spent.
With LLMs, we seem to witness the same speedup on that relative negligible 20%.

## "I am just one prompt away from getting the right results!"

About two weeks ago, I tried out Cursor myself on a Golang Template file.
Said file is already hard for us to maintain and comprehend, so it seemed a fair baseline.
Whilst the first suggestion worked (it took Cursor about 30 minutes to think), one small requirement change made it impossible for Cursor to produce a correct result.
For a good 12 hours, over the course of 1 1/2 days, I tried to prompt it such that it yields what we needed.
Eventually, I noticed that **my prompts converged** more and more **to be almost the code** I wanted.
After still not getting a working result, I ended up implementing it myself in less than 30 minutes.

The more niche a topic is, the worse seem to be the LLM's results.
For about 3 months now I am a Neovim user, before I never used neither Vim nor Nvim (adjusting git config to use nano was one of my first steps on a new OS).
As other Nvim users know, you end up configuring a lot.
Some of these configurations come from plugins, others are native to Vim.
Overall, I made the _great_ experience to get myself into "I am just one prompt away from getting the right configuration"...
eventually, I look at the clock, see that I spent 30 minutes on what seems to be a 2 line configuration, and end up using Google, GitHub and Reddit to find the right answer within seconds.
This experience is shared among peers, where AI traps you into the thinking "I am only one prompt away", whilst cleary it just does not know the answer. 
You can try it yourself the next time you are trapped.
Prompt the solution back to your favorite coding tool and ask it if this works, or why the solution does/not work.
Prepare yourself a tea beforehand, to enjoy the storytelling.

Another example stems from Go.
Since January I am using Golang, and it seems that Golang adds features that are adopted almost as soon as they are released.
One example that found adoption near instant are [range loops with integers (gobyexample)](https://gobyexample.com/for).
We're 9 months past [Golang's 1.23 Release](https://go.dev/doc/go1.23), whilst ChatGPT still seem to be unaware of it.
Whenever its creating a for loop, you will see the old `for i := 0; i < n; i++` syntax. 
In a PR last week, an AI review bot told me that Go version 1.24 does not exist, although it's been [released since February 2025](https://go.dev/doc/devel/release#go1.24.0).

At work I got to witness a conversation less than two weeks ago, where people were discussing that Cursor on a large-ish codebase does not work well with their rules.
It is natural that the bigger the code base the more rules you want to have, to avoid just one more edge-case and live hands-off.
Think of it like your code, the more cases you support, the more "if"s you end up with, eventually.
An engineer pointed out that some rules seem to be ignored as of recent.
To their conclusion, the prompt in Cursor is appended to the rules, i.e. the full content of the rules file + the prompt are fed into Cursor when making a request.
Every. single. request.
Thus, a too large ruleset won't fit into the context window, and your code ends up not looking as expected, given the large amount of rules.

## No forward-looking statements

{{< quote source="Wikipedia" url="https://en.wikipedia.org/wiki/Forward-looking_statement">}}
A forward-looking statement predicts, projects, or uses future events as expectations or possibilities
{{< /quote >}}

If I recall correctly, the first time I encountered that statement was in the context of shareholders, acquisitions and such.
This might be the most accurate statement for the future of A(G)I for coding.
It's just perfectly aligned with "We can't promise anything", and one should think people won't then, but at the same time any possible kind of claim has been made - excluding those that LLMs make themselves.

Whilst LLMs and AI these days seem to be truly helpful tools, we should come back to a more nuanced reality.
Companies have yet to prove that AI as a mostly autonomous assistant can live up to its promises, but all we see is that _it depends_.
Right now, _it depends_ a lot more towards the side of overpromises, rather than meeting the big expectations.

Many engineers, myself included, are probably using AI tools regularly in their day-to-day life.
Much so like using Google Search, opening a book, reading a documentation or eating breakfast.

Bottom line: We're having quite exciting times ahead of us.
It would be great if AI could prove what is proclaimed these days - But I have my doubts.
I wonder if we're going to see job roles with descriptions of "We need engineers to help us untangle the AI mess we created".
If that happens to be the case, I hope that [Google Search will be back from the dead](https://www.wheresyoured.at/the-men-who-killed-google/).

{{< quote author="CEOs these days" source="whatever date you're reading this">}}
We're just 6 months away from AGI.
{{< /quote >}}
