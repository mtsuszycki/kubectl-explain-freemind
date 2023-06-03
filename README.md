# kubectl-explain-freemind

Create a mind map from 'kubectl explain'
so the whole kubectl API can be viewed (in mindmup.com or freemind) as a big tree, a mind map, with descriptions

In other words, this bash script to add descriptions to 
kubectl explain 'something' --recursive

--recursive gives the view of the whole subtree but does not include description

That script will add the descriptions for all elements in the subtree and will output the text in tab format
so it can be converted to a FreeMind xml, that can be imported to mindmup.com

How to use:

kubectl explain pod --recursive | ./kube-explain-reformat.sh pod > pod.txt
kubectl explain pod.spec.containers --recursive | ./kube-explain-reformat.sh pod.spec.containers
kubectl explain csinodes --recursive | ./kube-explain-reformat.sh csinodes

etc.
The first and only argument need to be the same as subtree spec give to kubectl explain.
To see all api resources run:
kubectl api-resources

Once you have the tabulator separated output with descriptions, you can use
text-to-freemind.py
tool to convert it to a xml format that can be imported to Mindmup or Freemap.

Original version for python < 3 written by wbolster is here:
https://github.com/wbolster/text-to-freemind

