import type { DomainEvent, JourneyStartedEvent } from '../events/domain_events.js';

export interface JourneyReadModel {
    id: string;
    title: string;
    startDate: string;
    status: string;
}

export class QueryHandler {
    private journeys: Map<string, JourneyReadModel> = new Map();

    // In a real scenario, this would be triggered by an Event Bridge or DynamoDB Stream
    project(event: DomainEvent) {
        switch (event.type) {
            case 'JourneyStarted':
                const startEvent = event as JourneyStartedEvent;
                this.journeys.set(startEvent.aggregateId, {
                    id: startEvent.aggregateId,
                    title: startEvent.data.title,
                    startDate: startEvent.data.startDate,
                    status: 'Active'
                });
                break;
        }
    }

    getJourneys(): JourneyReadModel[] {
        return Array.from(this.journeys.values());
    }
}
