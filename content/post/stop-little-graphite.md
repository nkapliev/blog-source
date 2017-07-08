+++
title = "Stop, Little Graphite"
date = "2017-07-08T16:23:38+01:00"
draft = true
+++

**Q**: I have stopped reporting some counters to `graphite` and removed folders/counters related to them. Why `graphite` recreates deleted folders/counters?  
**A**: Most probably because some of your applications are still reporting removed counters. And `graphite` just doing what it suppose to do: storing them.  
So, the first thing to do you should check that changes in your applications that prevent old counters from reporting have been deployed for real.  
Go to instances/containers whith your application and check its source code.  
 
**Q**: Done! Changes deployed but `graphite` still recreates counters/folders. What should I do next?  
**A**: Do you use `statsd`/`carbon-aggregator`/etc.? Probably you are. Restart them.  
The problem could be related to empty counters that aggregators(e.g. `statsd`) trying to report to `graphite` again and again, even after nobody else asks them to do so.  
You need to restart `statsd`. This way you will force it to release old counters, and it will stop reporting them.  
Do not forget to restart `statsd` on the same instance with your `graphite` if you have it there.  

Also, there is an option in a `statsd` config that forces it to stop report empty counters: `deleteIdleStats`.  
Please read [some](https://grafana.com/blog/2016/03/03/25-graphite-grafana-and-statsd-gotchas/#nulls.deleteIdleStats) [docs](https://github.com/etsy/statsd/pull/348) before changing it ;)  

Another way to check that `statsd` is a cause of your troubles is to connect to its admin interface and look what counters `statsd` are aggregating right now and going to report to `graphite`:  
```
telnet 127.0.0.1 8126
counters
```  
Read more about `statsd` admin cli in [docs](https://github.com/etsy/statsd/blob/master/docs/admin_interface.md).  
 
**Q**: Done, aggregators restarted. But `graphite` still recreates counters/folders.  
**A**: Sometimes `statsd` need to be restarted several times. Have no idea why :(  

I hope you will solve the problem using this advice.  
If you will not, please tell me what solution did you find for your case.

