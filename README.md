# SyncNet


Here we have a "minimal working example" implementation of a Kuramoto network model. These models are based on the theory of weakly coupled oscillators. Here the approach assumes that nodes in a network are active, self-sustained oscillators, whose behaviour can be approximated by knowing their phase relations (Kuramoto, 1995; Hansel, 1995). 

In the present example: 

* There are six interacting nodes
* Initial conditions are all set to random 


<img src="https://github.com/nicogravel/SyncNet/blob/main/mwe/KuramotoSim.png" width=40%><img src="https://github.com/nicogravel/SyncNet/blob/main/mwe/KuramotoPhaseDiffDyn.png" width=50%>


*Left:* The Kuramoto order parameter for phase relations and its standard deviation are plottes as a funtion of the global coupling function. *Right:* Histogram of phase relationships (from *-pi* to *pi*) as a function of time step (procedural dependent units). The white trace corresponds to the Kuramoto order parameter (coherence in phase relations). The variability in this (spatiotemporal order) paramater it is sometimes taken as a footprint of metastability in the underlying system (black trace in roght panel).


### Background

* Mean field approximation of systems at the cusp of instability (Deco et al., 2027).
* Self-organized criticality in the dynamical working point of the brain enables optimal information encoding and computations.
* Local phase clustering --> segregation, Global phase clustering --> integration



### Shortcomings

* Difficulties in defining empirical structural connectivity
* Physiological variability
* Measurement uncertainty
* Interpretability 

