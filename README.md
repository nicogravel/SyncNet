# SyncNet: A Toy Kuramoto Model


Phase synchronization network model based on the theory of weakly coupled oscillators. This approach assumes that nodes in a network are active, self-sustained oscillators, whose behaviour can be approximated by knowing their phase relations (Kuramoto, 1995; Hansel, 1995). There are six nodes. Initial conditions are all set to random. A random connectivity matrix is fed into the model to simulate dynamics of phase relations. 


*Left:* The Kuramoto order parameter for phase relations and its standard deviation are plottes as a funtion of the global coupling function. *Right:* Histogram of phase relationships (from *-pi* to *pi*) as a function of time step (procedural dependent units). The white trace corresponds to the standard deviation of the Kuramoto order parameter (phase differences coherence). The variability in this spatiotemporal order paramater as a fingerprint of metastability.

<img src="https://github.com/nicogravel/SyncNet/blob/main/mwe/KuramotoSim.png" width=50%><img src="https://github.com/nicogravel/SyncNet/blob/main/mwe/KuramotoPhaseDiffDyn.png" width=50%>


### Background

* Mean field approximation of systems at the cusp of instability (Deco et al., 2027).
* Self-organized criticality in the dynamical working point of the brain enables optimal information encoding and computations.
* Local phase clustering --> segregation, Global phase clustering --> integration.



### Shortcomings

* Difficulties in defining empirical structural connectivity.
* Physiological variability.
* Measurement uncertainty.
* Interpretability. 

