# multiAgents.py
# --------------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
#
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


from util import manhattanDistance
from game import Directions
import random
import util

from game import Agent
from pacman import GameState


class ReflexAgent(Agent):
    """
    A reflex agent chooses an action at each choice point by examining
    its alternatives via a state evaluation function.

    The code below is provided as a guide.  You are welcome to change
    it in any way you see fit, so long as you don't touch our method
    headers.
    """

    def getAction(self, gameState: GameState):
        """
        You do not need to change this method, but you're welcome to.

        getAction chooses among the best options according to the evaluation function.

        Just like in the previous project, getAction takes a GameState and returns
        some Directions.X for some X in the set {NORTH, SOUTH, WEST, EAST, STOP}
        """
        # Collect legal moves and successor states
        legalMoves = gameState.getLegalActions()

        # Choose one of the best actions
        scores = [self.evaluationFunction(
            gameState, action) for action in legalMoves]
        bestScore = max(scores)
        bestIndices = [index for index in range(
            len(scores)) if scores[index] == bestScore]
        # Pick randomly among the best
        chosenIndex = random.choice(bestIndices)

        "Add more of your code here if you want to"

        return legalMoves[chosenIndex]

    def evaluationFunction(self, currentGameState: GameState, action):
        """
        Design a better evaluation function here.

        The evaluation function takes in the current and proposed successor
        GameStates (pacman.py) and returns a number, where higher numbers are better.

        The code below extracts some useful information from the state, like the
        remaining food (newFood) and Pacman position after moving (newPos).
        newScaredTimes holds the number of moves that each ghost will remain
        scared because of Pacman having eaten a power pellet.

        Print out these variables to see what you're getting, then combine them
        to create a masterful evaluation function.
        """
        # Useful information you can extract from a GameState (pacman.py)
        successorGameState = currentGameState.generatePacmanSuccessor(action)
        newPos = successorGameState.getPacmanPosition()
        newFood = successorGameState.getFood()

        newGhostStates = successorGameState.getGhostStates()
        newScaredTimes = [
            ghostState.scaredTimer for ghostState in newGhostStates]
        newGhostPos = [ghostState.getPosition()
                       for ghostState in newGhostStates]
        if not newFood.asList():
            foodScore = - newFood.count()
        else:
            foodScore = - newFood.count() + 0.20 / \
                (min([manhattanDistance(newPos, p)
                 for p in newFood.asList()]) + 1)
        fleedAgent = - 1.1 / \
            (max([manhattanDistance(newPos, p) for p in newGhostPos]) + 1)
        return 0.5 * foodScore + 0.3 * fleedAgent


def scoreEvaluationFunction(currentGameState: GameState):
    """
    This default evaluation function just returns the score of the state.
    The score is the same one displayed in the Pacman GUI.

    This evaluation function is meant for use with adversarial search agents
    (not reflex agents).
    """
    return currentGameState.getScore()


class MultiAgentSearchAgent(Agent):
    """
    This class provides some common elements to all of your
    multi-agent searchers.  Any methods defined here will be available
    to the MinimaxPacmanAgent, AlphaBetaPacmanAgent & ExpectimaxPacmanAgent.

    You *do not* need to make any changes here, but you can if you want to
    add functionality to all your adversarial search agents.  Please do not
    remove anything, however.

    Note: this is an abstract class: one that should not be instantiated.  It's
    only partially specified, and designed to be extended.  Agent (game.py)
    is another abstract class.
    """

    def __init__(self, evalFn='scoreEvaluationFunction', depth='2'):
        self.index = 0  # Pacman is always agent index 0
        self.evaluationFunction = util.lookup(evalFn, globals())
        self.depth = int(depth)


class MinimaxAgent(MultiAgentSearchAgent):
    """
    Your minimax agent (question 2)
    """

    def getAction(self, gameState: GameState):
        """
        Returns the minimax action from the current gameState using self.depth
        and self.evaluationFunction.

        Here are some method calls that might be useful when implementing minimax.

        gameState.getLegalActions(agentIndex):
        Returns a list of legal actions for an agent
        agentIndex=0 means Pacman, ghosts are >= 1

        gameState.generateSuccessor(agentIndex, action):
        Returns the successor game state after an agent takes an action

        gameState.getNumAgents():
        Returns the total number of agents in the game

        gameState.isWin():
        Returns whether or not the game state is a winning state

        gameState.isLose():
        Returns whether or not the game state is a losing state
        """
        # successors: a list of (state, action) pair
        successors = [(gameState.generateSuccessor(0, action), action)
                      for action in gameState.getLegalActions(0)]
        return max(successors, key=lambda s: self.minimax_val(1, s[0], 0))[1]

    def minimax_val(self, agent, gameState: GameState, depth):
        """
        Implementing minimax with one agent and several adversaries

        Args:
            agent (int): the current agent taking action
            gameState (GameState): start game state for evaluation.
            depth (int): depth of the current search.

        Returns:
            int: evaluation score for the gamestate
        """
        # Reaching terminal state
        if gameState.isWin() or gameState.isLose() or depth == self.depth:
            return self.evaluationFunction(gameState)
        nextAgent = agent + 1
        # Pacman's (maximizer) turn
        if agent == 0:
            return max([self.minimax_val(nextAgent, gameState.generateSuccessor(agent, action), depth) for action in gameState.getLegalActions(agent)])
        # Ghosts' turn
        else:
            if nextAgent == gameState.getNumAgents():
                nextAgent = 0
                depth += 1
            return min([self.minimax_val(nextAgent, gameState.generateSuccessor(agent, action), depth) for action in gameState.getLegalActions(agent)])


class AlphaBetaAgent(MultiAgentSearchAgent):
    """
    Your minimax agent with alpha-beta pruning (question 3)
    """

    def getAction(self, gameState: GameState):
        """
        Returns the minimax action using self.depth and self.evaluationFunction
        """
        successors = [(gameState.generateSuccessor(0, action), action)
                      for action in gameState.getLegalActions(0)]
        v = float('-inf')
        alpha = float('-inf')
        beta = float('inf')
        bestAction = successors[0][1]
        for s in successors:
            v = max(v, self.minimax_prune_val(1, s[0], alpha, beta, 0))
            if v > beta:
                return bestAction
            if alpha < v:
                bestAction = s[1]
                alpha = v
        return bestAction

    def minimax_prune_val(self, agent, gameState: GameState, alpha, beta, depth):
        """
        Implementing minimax tree with multiple minimizers, along with alpha-beta pruning.

        Args:
            agent (int): indicator of the current agent
            gameState (GameState): the current gamestate
            alpha (float): maximum score of already searched nodes
            beta (float): minimum score of already searched nodes
            depth (int): the current depth

        Returns:
            int: score of the node
        """
        if gameState.isWin() or gameState.isLose() or depth == self.depth:
            return self.evaluationFunction(gameState)
        if agent == 0:
            v = float('-inf')
            for action in gameState.getLegalActions(0):
                s = gameState.generateSuccessor(0, action)
                v = max(v, self.minimax_prune_val(1, s, alpha, beta, depth))
                if v > beta:
                    return v
                alpha = max(alpha, v)
            return v
        else:
            v = float('inf')
            nextAgent = agent + 1
            if nextAgent == gameState.getNumAgents():
                nextAgent = 0
                depth += 1
            for action in gameState.getLegalActions(agent):
                s = gameState.generateSuccessor(agent, action)
                v = min(v, self.minimax_prune_val(
                    nextAgent, s, alpha, beta, depth))
                if v < alpha:
                    return v
                beta = min(beta, v)
            return v


class ExpectimaxAgent(MultiAgentSearchAgent):
    """
      Your expectimax agent (question 4)
    """

    def getAction(self, gameState: GameState):
        """
        Returns the expectimax action using self.depth and self.evaluationFunction

        All ghosts should be modeled as choosing uniformly at random from their
        legal moves.
        """
        successors = [(gameState.generateSuccessor(0, action), action)
                      for action in gameState.getLegalActions(0)]
        v = float('-inf')
        bestAction = successors[0][1]
        for s in successors:
            new_v = self.expectimax_val(1, s[0], 0)
            if v < new_v:
                bestAction = s[1]
                v = new_v
        return bestAction

    def expectimax_val(self, agent, gameState: GameState, depth):
        """
        Calculates expectimax value. 

        Args:
            agent (int): the current agent. 0 is Pacman. 
            gameState (GameState): the current state.
            depth (int): current search depth.

        Returns:
            int: score of this move
        """

        # Reaching terminal state
        if gameState.isWin() or gameState.isLose() or depth == self.depth:
            return self.evaluationFunction(gameState)
        nextAgent = agent + 1

        # Pacman's (maximizer) turn
        if agent == 0:
            return max([self.expectimax_val(nextAgent, gameState.generateSuccessor(agent, action), depth) for action in gameState.getLegalActions(agent)])

        # Ghosts' turn
        else:
            if nextAgent == gameState.getNumAgents():
                nextAgent = 0
                depth += 1
            return sum([self.expectimax_val(nextAgent, gameState.generateSuccessor(agent, action), depth) for action in gameState.getLegalActions(agent)]) / len(gameState.getLegalActions(agent))


def betterEvaluationFunction(currentGameState: GameState):
    """
    Your extreme ghost-hunting, pellet-nabbing, food-gobbling, unstoppable
    evaluation function (question 5).

    DESCRIPTION: 
    ghost_hunt: awards eating ghosts, and punishes small distance between pacman and
    ghost position
    food_gooble: if eats all food, AWARD! awards reducing food counts.
    pellet_nabbing: awards getting closer to the closest food pellet
    unstoppable: awards getting higher score
    """
    ghost_hunt = - 0.1 * (currentGameState.getNumAgents() - 1) - 0.1 * min([manhattanDistance(
        currentGameState.getPacmanPosition(), s) for s in currentGameState.getGhostPositions()])
    if currentGameState.getFood().count():
        food_gobble = - 0.5 / currentGameState.getFood().count()
        pellet_nabbing = 1 / max([manhattanDistance(currentGameState.getPacmanPosition(), s)
                                 for s in currentGameState.getFood().asList()])
    else:
        food_gobble = 100
        pellet_nabbing = 0
    unstoppable = 0.5 * currentGameState.getScore()
    return ghost_hunt + food_gobble + pellet_nabbing + unstoppable


# Abbreviation
better = betterEvaluationFunction
