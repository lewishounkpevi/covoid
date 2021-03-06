% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/1-sir-cm-model.R
\name{sir_c_state0}
\alias{sir_c_state0}
\title{Age structured SIR model inital state}
\usage{
sir_c_state0(S, I, R)
}
\arguments{
\item{S}{Initial number of susceptibles}

\item{I}{Initial number of infected}

\item{R}{Initial number of removed}
}
\value{
List of SIR model initial states
}
\description{
\Sexpr[results=rd, stage=render]{lifecycle::badge("maturing")}

Define intial state values for age structured SIR models
}
