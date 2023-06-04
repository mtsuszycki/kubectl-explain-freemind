# kubectl-explain-freemind

Create a mind map from 'kubectl explain'
so the whole kubectl API can be viewed (in mindmup.com or freemind) as a big tree, a mind map, with descriptions, 
to visualize kubectl api objects and their relations.

If you are lazy or don't need the script, I attach kube-api.mm, which can be imported directly to MindMup or
FreeMind. It's the whole kubectl api tree as of 04th June 2023.
It's pretty big, so be patient while importing to MindMup. It took a couple of minutes to import it to my MindMup.

Screenshot from MindMup showing first level of the tree, the rest is collapsed
![20230604-144733](https://github.com/mtsuszycki/kubectl-explain-freemind/assets/3226505/2f1b92f8-42b9-4acc-b22e-57629697c1d5)


One level of 'namespaces'  with Top-Down theme.
![20230604-144752](https://github.com/mtsuszycki/kubectl-explain-freemind/assets/3226505/41059ad9-f5bd-4646-a97a-d728cc023116)

'namespaces' subtree, unfolded:
![20230604-144840](https://github.com/mtsuszycki/kubectl-explain-freemind/assets/3226505/ee94ab51-d609-4c44-9f69-feace91dfb3c)


MindMup automatically supports http links in descriptions, which is handy.
Also it has themes (e.g 'top-down') than can show the tree in different ways. Also it support storyboards. 

The kube-explain-reformat.sh bash script adds descriptions to 
kubectl explain 'something' --recursive

--recursive gives the view of the whole subtree but does not include description

The script produces the output in tab format
so it can be converted to a FreeMind xml, that can be imported to mindmup.com

How to use:
```
kubectl explain pod --recursive | ./kube-explain-reformat.sh pod > pod.txt
kubectl explain pod.spec.containers --recursive | ./kube-explain-reformat.sh pod.spec.containers
kubectl explain csinodes --recursive | ./kube-explain-reformat.sh csinodes
```
etc.
The first and only argument need to be the same as subtree spec given to 'kubectl explain'.
To see all api resources run:
kubectl api-resources

NOTE: this bash script is not optimized, it calls 'kubectl explain ' for each element in the subtree
to get the description.

Once you have the output (tabulator separated text with descriptions), you can use
```
text-to-freemind.py
```
tool to convert it to a xml format that can be imported to Mindmup or Freemap.

So, from the example above, assuming that you have created pod.txt file, convert it to xml:
```
text-to-freemind.py pod.txt > pod.mm
```
.mm is a MindMup extension.

Do many subtrees in a loop:
```
for item in services roles secrets resourcequotas namespaces networkpolicies replicasets replicationcontrollers ingresses jobs leases events endpoints deamonsets cronjobs bindings;
  do 
   echo "doing $item"  
   kubectl explain $item --recursive | ./kube-explain-reformat.sh $item > ${item}.txt ; ./text-to-freemind.py ${item}.txt > ${item}.mm ;
   done

```
Do all api-resources subtrees in a loop:
```
# tail is to skip the first header line
 kubectl api-resources | tail -n +2 | awk '{print $1}' | while read item ; do 
  echo "checking $item" 
  [ -r ${item}.mm ] && { echo "already exists"; continue; } 
  echo "doing $item"  
  kubectl explain $item --recursive | ./kube-explain-reformat.sh $item > ${item}.txt ; ./text-to-freemind.py ${item}.txt > ${item}.mm ; done
 
 ```

Then go to a MindMup web interface, File -> Import -> upload a file . Drag n drop pod.mm 
and after a while you should see big Mind Map for a kubectl pod API. Use 'F' key to collapse subtrees.


I include modified version of text-to-freemind.py that works with Python 3 or newer.
I'm not the author of text-to-freemind.py.
Original version for python < 3 written by wbolster is here:
https://github.com/wbolster/text-to-freemind

