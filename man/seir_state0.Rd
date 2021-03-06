% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/1-seir-model.R
\name{seir_state0}
\alias{seir_state0}
\title{SEIR model inital state}
\usage{
seir_state0(S, E, I = 0, R = 0)
}
\arguments{
\item{S}{Initial number of susceptibles}

\item{E}{Initial number of exposed (non-infectious)}

\item{I}{Initial number of infected}

\item{R}{Initial number of removed}
}
\value{
List of SEIR model initial states
}
\description{
\Sexpr[results=rd, stage=render]{lifecycle::badge("maturing")}

Setup function
}
