# QD-shot
This script adds immersive player damage effects for RedM, simulating injuries with visual and gameplay mechanics like ragdolling, drunken camera effects, and reduced movement or accuracy.

# Features
Dynamic Injury Simulation:

Arm injuries reduce weapon handling, and force the player to unequip weapons.
Leg injuries cause ragdoll effects and slow player movement.
Visual & Gameplay Effects:

Drunken camera shake and timecycle modifiers to simulate player hurt state.
Motion blur and accuracy reduction for severe injuries.
Automatic Damage Monitoring:

Detects damage to specific bones and applies corresponding effects.
Hurt State Recovery:

Gradually heals the player over time, restoring normal state once fully healed.

# Installation
Clone or download the repository.
Place the script in your RedM resource folder.
Add the resource to your server.cfg:

ensure qd_shot
